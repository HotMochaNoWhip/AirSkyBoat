-----------------------------------
-- Monster TP Moves Global
-- NOTE: A lot of this is good estimating since the FFXI playerbase has not found all of info for individual moves.
-- What is known is that they roughly follow player Weaponskill calculations (pDIF, dMOD, ratio, etc) so this is what
-- this set of functions emulates.
-----------------------------------
require("scripts/globals/magicburst")
require("scripts/globals/status")
require("scripts/globals/magic")
require("scripts/globals/utils")
require("scripts/globals/msg")
require("scripts/globals/weaponskills")
require("scripts/globals/damage")
-----------------------------------
xi = xi or {}
xi.mobskills = xi.mobskills or {}

-- mob types
-- used in mob:isMobType()
xi.mobskills.mobType =
{
    NORMAL      = 0x00,
    UNUSED      = 0x01,
    NOTORIOUS   = 0x02,
    FISHED      = 0x04,
    CALLED      = 0x08,
    BATTLEFIELD = 0x10,
    EVENT       = 0x20,
}

xi.mobskills.drainType =
{
    HP = 0,
    MP = 1,
    TP = 2,
}

-- shadowbehav (number of shadows to take off)
xi.mobskills.shadowBehavior =
{
    IGNORE_SHADOWS = 0,
    NUMSHADOWS_1   = 1,
    NUMSHADOWS_2   = 2,
    NUMSHADOWS_3   = 3,
    NUMSHADOWS_4   = 4,
    WIPE_SHADOWS   = 999,
}

xi.mobskills.physicalTpBonus =
{
    ACC_VARIES  = 0,
    ATK_VARIES  = 1,
    DMG_VARIES  = 2,
    CRIT_VARIES = 3,
}

xi.mobskills.magicalTpBonus =
{
    NO_EFFECT   = 0,
    MACC_BONUS  = 1,
    MAB_BONUS   = 2,
    DMG_BONUS   = 3,
    RANGED      = 4,
}

local function getDexCritRate(source, target)
    -- https://www.bg-wiki.com/bg/Critical_Hit_Rate
    local dDex = source:getStat(xi.mod.DEX) - target:getStat(xi.mod.AGI)
    local dDexAbs = math.abs(dDex)

    local sign = 1
    if dDex < 0 then
        -- target has higher AGI so this will be a decrease to crit rate
        sign = -1
    end

    -- default to +0 crit rate for a delta of 0-6
    local critRate = 0
    if dDexAbs > 39 then
        -- 40-50: (dDEX-35)
        critRate = dDexAbs - 35
    elseif dDexAbs > 29 then
        -- 30-39: +4
        critRate = 4
    elseif dDexAbs > 19 then
        -- 20-29: +3
        critRate = 3
    elseif dDexAbs > 13 then
        -- 14-19: +2
        critRate = 2
    elseif dDexAbs > 6 then
        -- 7-13: +1
        critRate = 1
    end

    -- Crit rate from stats caps at +-15
    return math.min(critRate, 15) * sign
end

local function calculateMobMagicBurst(caster, ele, target)
    local burst = 1.0
    local skillchainTier, skillchainCount = MobFormMagicBurst(ele, target)

    if skillchainTier > 0 then
        if skillchainCount == 1 then
            burst = 1.3
        elseif skillchainCount == 2 then
            burst = 1.35
        elseif skillchainCount == 3 then
            burst = 1.40
        elseif skillchainCount == 4 then
            burst = 1.45
        elseif skillchainCount == 5 then
            burst = 1.50
        else
            -- Something strange is going on if this occurs.
            burst = 1.0
        end
    end

    return burst
end

local function getBarSpellDefBonus(mob, target, spellElement)
    if spellElement >= xi.magic.element.FIRE and spellElement <= xi.magic.element.WATER then
        if target:hasStatusEffect(xi.magic.barSpell[spellElement]) then -- bar- spell magic defense bonus
            return target:getStatusEffect(xi.magic.barSpell[spellElement]):getSubPower()
        end
    end
end

xi.mobskills.mobRangedMove = function(mob, target, skill, numberofhits, accmod, dmgmod, tpeffect)
    -- this will eventually contian ranged attack code
    return xi.mobskills.mobPhysicalMove(mob, target, skill, numberofhits, accmod, dmgmod, xi.mobskills.magicalTpBonus.RANGED)
end

-- PHYSICAL MOVE FUNCTION
-- Call this on every physical move!
-- accmod is a linear multiplier for accuracy (1 default)
-- dmgmod is a linear multiplier for damage (1 default)
-- tpeffect is an enum which can be one of:
-- 0 xi.mobskills.physicalTpBonus.ACC_VARIES
-- 1 xi.mobskills.physicalTpBonus.ATK_VARIES
-- 2 xi.mobskills.physicalTpBonus.DMG_VARIES
-- 3 xi.mobskills.physicalTpBonus.CRIT_VARIES
-- mtp100/200/300 are the three values for 100% TP, 200% TP, 300% TP just like weaponskills.lua
-- if xi.mobskills.physicalTpBonus.ACC_VARIES -> three values are acc %s (1.0 is 100% acc, 0.8 is 80% acc, 1.2 is 120% acc)
-- if xi.mobskills.physicalTpBonus.ATK_VARIES -> three values are attack multiplier (1.5x 0.5x etc)
-- if xi.mobskills.physicalTpBonus.DMG_VARIES -> three values are

xi.mobskills.mobPhysicalMove = function(mob, target, skill, numberofhits, accmod, dmgmod, tpeffect, mtp000, mtp150, mtp300, offcratiomod, wSC)
    local returninfo = { }
    local fStr = 0

    if wSC == nil then
        wSC = 0
    end

    --get dstr (bias to monsters, so no fSTR)
    if tpeffect == xi.mobskills.magicalTpBonus.RANGED then
        fStr = xi.weaponskills.fSTR2(mob:getStat(xi.mod.STR), target:getStat(xi.mod.VIT), mob:getWeaponDmgRank())
    else
        fStr = xi.weaponskills.fSTR(mob:getStat(xi.mod.STR), target:getStat(xi.mod.VIT), mob:getWeaponDmgRank())
    end

    --apply WSC
    local base = mob:getWeaponDmg() + fStr + wSC
    if base < 1 then
        base = 1
    end

    local lvldiff = mob:getMainLvl() - target:getMainLvl()

    --work out hit rate for mobs
    local hitrate = xi.weaponskills.getHitRate(mob, target, 0, 0)

    hitrate = utils.clamp(hitrate, 0.2, 0.95)

    --work out the base damage for a single hit
    local hitdamage = base + lvldiff
    if hitdamage < 1 then
        hitdamage = 0 -- If I hit below 1 I actually did 0 damage.
    end

    hitdamage = hitdamage * dmgmod

    local dmgrandsel = math.random(0, 1) -- Can select either positive or negative.
    local dmgrand = math.random(0, 5) -- Variance should be 0-5%
    if dmgrandsel == 0 then
        hitdamage = hitdamage + (hitdamage * (dmgrand / 100))
    else
        hitdamage = hitdamage - (hitdamage * (dmgrand / 100))
    end

    -- Calculating with the known era pdif ratio for weaponskills.
    if mtp000 == nil or mtp150 == nil or mtp300 == nil then -- Nil gate for xi.weaponskills.cMeleeRatio, will default mtp for each level to 1.
        mtp000 = 1.0
        mtp150 = 1.0
        mtp300 = 1.0
    end

    local params = { atk000 = mtp000, atk150 = mtp150, atk300 = mtp300 }
    local pdifTable = xi.weaponskills.cMeleeRatio(mob, target, params, 0, mob:getTP(), xi.slot.main)
    local pdif = pdifTable[1]
    local pdifcrit = pdifTable[2]

    -- start the hits
    local finaldmg = 0
    local hitsdone = 1
    local hitslanded = 0

    local baseCritRate = 5 -- Crit hit rate has a 5% base chance.
    local critRate = (baseCritRate + getDexCritRate(mob, target) + mob:getMod(xi.mod.CRITHITRATE)) / 100
    critRate = utils.clamp(critRate, 0, 1)

    local chance = math.random()
    chance = xi.weaponskills.handleParry(mob, target, chance)

    -- first hit has a higher chance to land
    local firstHitChance = hitrate + 0.5

    firstHitChance = utils.clamp(firstHitChance, 0.25, 0.95)

    if chance <= firstHitChance then -- it hit
        local isCrit = math.random() < critRate

        if isCrit then
            pdif = pdifcrit
        end

        finaldmg = finaldmg + hitdamage * pdif
        finaldmg = xi.weaponskills.handleBlock(mob, target, finaldmg)
        hitslanded = hitslanded + 1
    end

    while hitsdone < numberofhits do
        chance = math.random()
        pdifTable = xi.weaponskills.cMeleeRatio(mob, target, params, 0, mob:getTP(), xi.slot.main)
        pdif = pdifTable[1]
        pdifcrit = pdifTable[2]

        if chance <= hitrate then --it hit
            local isCrit = math.random() < critRate

            if isCrit then
                pdif = pdifcrit
            end

            finaldmg = finaldmg + hitdamage * pdif
            finaldmg = xi.weaponskills.handleBlock(mob, target, finaldmg)
            hitslanded = hitslanded + 1
        end

        hitsdone = hitsdone + 1
    end

    -- if an attack landed it must do at least 1 damage
    if hitslanded >= 1 and finaldmg < 1 then
        finaldmg = 0 -- If I hit below 1 I actually did 0 damage.
    end

    -- all hits missed
    if hitslanded == 0 or finaldmg == 0 then
        finaldmg = 0
        hitslanded = 0
        skill:setMsg(xi.msg.basic.SKILL_MISS)
    end

    if tpeffect == xi.mobskills.magicalTpBonus.RANGED then
        finaldmg = xi.damage.applyDamageTaken(target, finaldmg, xi.attackType.RANGED)
    else
        if target:getMod(xi.mod.PET_DMG_TAKEN_PHYSICAL) ~= 0 then
            finaldmg = finaldmg * (target:getMod(xi.mod.PET_DMG_TAKEN_PHYSICAL) / 100)
        end

        finaldmg = xi.damage.applyDamageTaken(target, finaldmg, xi.attackType.PHYSICAL)
    end

    returninfo.dmg = finaldmg
    returninfo.hitslanded = hitslanded

    return returninfo

end

-- MAGICAL MOVE
-- Call this on every magical move!
-- mob/target/skill should be passed from onMobWeaponSkill.
-- dmg is the base damage (V value), accmod is a multiplier for accuracy (1 default, more than 1 = higher macc for mob),
-- ditto for dmg mod but more damage >1 (equivalent of M value)
-- tpeffect is an enum from one of:
-- 0 = xi.mobskills.magicalTpBonus.NO_EFFECT
-- 1 = xi.mobskills.magicalTpBonus.MACC_BONUS
-- 2 = xi.mobskills.magicalTpBonus.MAB_BONUS
-- 3 = xi.mobskills.magicalTpBonus.DMG_BONUS
-- tpvalue affects the strength of having more TP along the following lines:
-- xi.mobskills.magicalTpBonus.NO_EFFECT -> tpvalue has no xi.effect.
-- xi.mobskills.magicalTpBonus.MACC_BONUS -> direct multiplier to macc (1 for default)
-- xi.mobskills.magicalTpBonus.MAB_BONUS -> direct multiplier to mab (1 for default)
-- xi.mobskills.magicalTpBonus.DMG_BONUS -> direct multiplier to damage (V+dINT) (1 for default)
--Examples:
-- xi.mobskills.magicalTpBonus.DMG_BONUS and TP=100, tpvalue = 1, assume V=150  --> damage is now 150*(TP*1)/100 = 150
-- xi.mobskills.magicalTpBonus.DMG_BONUS and TP=200, tpvalue = 1, assume V=150  --> damage is now 150*(TP*1)/100 = 300
-- xi.mobskills.magicalTpBonus.DMG_BONUS and TP=100, tpvalue = 2, assume V=150  --> damage is now 150*(TP*2)/100 = 300
-- xi.mobskills.magicalTpBonus.DMG_BONUS and TP=200, tpvalue = 2, assume V=150  --> damage is now 150*(TP*2)/100 = 600

xi.mobskills.mobMagicalMove = function(mob, target, skill, damage, element, dmgmod, tpeffect, tpvalue, ignoreresist)
    local returninfo = { }
    local ignoreres = ignoreresist or false

    --get all the stuff we need
    local resist = 1
    local barspellDef = 0
    local magicDefense = 1

    if
        element >= xi.magic.element.FIRE and
        element <= xi.magic.element.WATER and
        target:hasStatusEffect(xi.magic.barSpell[element])
    then -- bar- spell magic defense bonus
        barspellDef = getBarSpellDefBonus(mob, target, element)
    end

    local mab = (100 + mob:getMod(xi.mod.MATT)) / (100 + target:getMod(xi.mod.MDEF) + barspellDef)
    local bonusMacc = 0
    mab = utils.clamp(mab, 0.7, 1.3)

    if tpeffect == xi.mobskills.magicalTpBonus.DMG_BONUS then
        damage = damage * (((skill:getTP() / 10)*tpvalue) / 100)
    end

    -- resistence is added last
    local finaldmg = damage * mab * dmgmod

    magicDefense = xi.magic.getElementalDamageReduction(target, element)

    finaldmg = finaldmg * magicDefense

    if mob:isPet() and mob:getMaster():isPC() then
        local master = mob:getMaster()
        if (master:getPetID() >= 0 and master:getPetID() <= 20) then -- check to ensure pet is avatar
            bonusMacc = bonusMacc + utils.clamp(master:getSkillLevel(xi.skill.SUMMONING_MAGIC) - master:getMaxSkillLevel(mob:getMainLvl(), xi.job.SMN, xi.skill.SUMMONING_MAGIC), 0, 200)
        end
    end

    -- get resistence
    local params = { diff = (mob:getStat(xi.mod.INT)-target:getStat(xi.mod.INT)), skillType = nil, bonus = bonusMacc, element = element, effect = nil }
    resist = xi.magic.applyResistanceEffect(mob, target, nil, params) -- Uses magic.lua resistance calcs as this moves to a global use case.

    if not ignoreres then
        finaldmg = finaldmg * resist
    end

    if target:getMod(xi.mod.PET_DMG_TAKEN_MAGICAL) ~= 0 then
        finaldmg = finaldmg * (target:getMod(xi.mod.PET_DMG_TAKEN_MAGICAL) / 100)
    end

    local targetMDTA = xi.spells.damage.calculateTMDA(mob, target, element)

    finaldmg = finaldmg * targetMDTA

    returninfo.dmg = finaldmg

    return returninfo

end

-- effect = xi.effect.WHATEVER if enfeeble
-- statmod = the stat to account for resist (INT, MND, etc) e.g. xi.mod.INT
-- This determines how much the monsters ability resists on the player.
xi.mobskills.applyPlayerResistance = function(mob, effect, target, diff, bonus, element)
    local percentBonus = 0
    local magicaccbonus = 0

    if diff > 10 then
        magicaccbonus = magicaccbonus + 10 + (diff - 10)/2
    else
        magicaccbonus = magicaccbonus + diff
    end

    if bonus ~= nil then
        magicaccbonus = magicaccbonus + bonus
    end

    if effect ~= nil then
        percentBonus = percentBonus - xi.magic.getEffectResistance(target, effect)
    end

    local p = xi.magic.getMagicHitRate(mob, target, 0, element, percentBonus, magicaccbonus)

    return xi.magic.getMagicResist(p)
end

xi.mobskills.mobAddBonuses = function(caster, target, dmg, ele, ignoreres) -- used for SMN magical bloodpacts, despite the name.

    local ignore = ignoreres or false
    local magicDefense = xi.magic.getElementalDamageReduction(target, ele)

    if not ignore then dmg = math.floor(dmg * magicDefense) end

    local dayWeatherBonus = 1.00

    if caster:getWeather() == xi.magic.singleWeatherStrong[ele] then
        if math.random() < 0.33 then
            dayWeatherBonus = dayWeatherBonus + 0.10
        end
    elseif caster:getWeather() == xi.magic.singleWeatherWeak[ele] then
        if math.random() < 0.33 then
            dayWeatherBonus = dayWeatherBonus - 0.10
        end
    elseif caster:getWeather() == xi.magic.doubleWeatherStrong[ele] then
        if math.random() < 0.33 then
            dayWeatherBonus = dayWeatherBonus + 0.25
        end
    elseif caster:getWeather() == xi.magic.doubleWeatherWeak[ele] then
        if math.random() < 0.33 then
            dayWeatherBonus = dayWeatherBonus - 0.25
        end
    end

    if VanadielDayElement() == xi.magic.dayStrong[ele] then
        if math.random() < 0.33 then
            dayWeatherBonus = dayWeatherBonus + 0.10
        end
    elseif VanadielDayElement() == xi.magic.dayWeak[ele] then
        if math.random() < 0.33 then
            dayWeatherBonus = dayWeatherBonus - 0.10
        end
    end

    if dayWeatherBonus > 1.35 then
        dayWeatherBonus = 1.35
    end

    dmg = math.floor(dmg * dayWeatherBonus)

    local burst = calculateMobMagicBurst(caster, ele, target)
    dmg = math.floor(dmg * burst)

    local mdefBarBonus = 0
    if
        ele >= xi.magic.element.FIRE and
        ele <= xi.magic.element.WATER and
        target:hasStatusEffect(xi.magic.barSpell[ele])
    then -- bar- spell magic defense bonus
        mdefBarBonus = target:getStatusEffect(xi.magic.barSpell[ele]):getSubPower()
    end
    local mab = (100 + caster:getMod(xi.mod.MATT)) / (100 + target:getMod(xi.mod.MDEF) + mdefBarBonus)

    dmg = math.floor(dmg * mab)

    return dmg
end

-- Calculates breath damage
-- mob is a mob reference to get hp and lvl
-- percent is the percentage to take from HP
-- base is calculated from main level to create a minimum
-- Equation: (HP * percent) + (LVL / base)
-- cap is optional, defines a maximum damage
xi.mobskills.mobBreathMove = function(mob, target, percent, base, element, cap)
    local damage = (mob:getHP() * percent) + (mob:getMainLvl() / base)

    if cap == nil then
        -- cap max damage
        cap = math.floor(mob:getHP()/5)
    end

    -- Deal bonus damage vs mob ecosystem
    local systemBonus = utils.getSystemStrengthBonus(mob, target)
    damage = damage + damage * (systemBonus * 0.25)

    -- elemental resistence
    if element ~= nil and element > 0 then
        -- no skill available, pass nil
        -- get resistence
        local params = { diff = (mob:getStat(xi.mod.INT)-target:getStat(xi.mod.INT)), skillType = nil, bonus = 0, element = element, effect = nil }
        local resist = xi.magic.applyResistanceEffect(mob, target, nil, params) -- Uses magic.lua resistance calcs as this moves to a global use case.

        -- get elemental damage reduction
        local defense = xi.magic.getElementalDamageReduction(target, element)

        damage = damage * resist * defense
    end

    damage = utils.clamp(damage, 1, cap)

    if target:getMod(xi.mod.PET_DMG_TAKEN_BREATH) ~= 0 then
        damage = damage * (target:getMod(xi.mod.PET_DMG_TAKEN_BREATH) / 100)
    end

    local liement = target:checkLiementAbsorb(xi.damageType.ELEMENTAL + element) -- check for Liement.
    if liement < 0 then -- skip BDT/DT etc for Liement if we absorb.
        return math.floor(damage * liement)
    end

    -- The values set for this modifiers are base 10,000.
    -- -2500 in item_mods.sql means -25% damage recived.
    -- 2500 would mean 25% ADDITIONAL damage taken.
    -- The effects of the "Shell" spells are also included in this step. The effect also aplies a negative value.

    damage = xi.damage.applyDamageTaken(target, damage, xi.attackType.BREATH)

    if target:hasStatusEffect(xi.effect.ALL_MISS) and target:getStatusEffect(xi.effect.ALL_MISS):getPower() > 1 then
        return 0
    end

    -- Handle Phalanx
    if damage > 0 then
        damage = utils.clamp(damage - target:getMod(xi.mod.PHALANX), 0, 99999)
    end

    -- Handle Stoneskin
    if damage > 0 then
        damage = utils.clamp(utils.stoneskin(target, damage), -99999, 99999)
    end

    return damage
end

xi.mobskills.mobFinalAdjustments = function(dmg, mob, skill, target, attackType, damageType, shadowbehav)

    -- If target has Hysteria, no message skip rest
    if mob:hasStatusEffect(xi.effect.HYSTERIA) then
        skill:setMsg(xi.msg.basic.NONE)
        return 0
    end

    -- physical attack missed, skip rest
    if skill:hasMissMsg() then
        return 0
    end

    --handle pd
    if
        (target:hasStatusEffect(xi.effect.PERFECT_DODGE) or
        target:hasStatusEffect(xi.effect.ALL_MISS)) and
        attackType== xi.attackType.PHYSICAL
    then
        skill:setMsg(xi.msg.basic.SKILL_MISS)
        return 0
    end

    -- handle super jump
    if target:hasStatusEffect(xi.effect.ALL_MISS) and target:getStatusEffect(xi.effect.ALL_MISS):getPower() > 1 then
        skill:setMsg(xi.msg.basic.SKILL_MISS)
        return 0
    end

    -- set message to damage
    -- this is for AoE because its only set once
    skill:setMsg(xi.msg.basic.DAMAGE)

    --Handle shadows depending on shadow behaviour / attackType
    if shadowbehav ~= xi.mobskills.shadowBehavior.WIPE_SHADOWS and shadowbehav ~= xi.mobskills.shadowBehavior.IGNORE_SHADOWS then --remove 'shadowbehav' shadows.

        dmg = utils.takeShadows(target, mob, dmg, shadowbehav)

        -- dealt zero damage, so shadows took hit
        if dmg == 0 then
            skill:setMsg(xi.msg.basic.SHADOW_ABSORB)
            return shadowbehav
        end

    elseif shadowbehav == xi.mobskills.shadowBehavior.WIPE_SHADOWS then --take em all!
        target:delStatusEffect(xi.effect.COPY_IMAGE)
        target:delStatusEffect(xi.effect.BLINK)
        target:delStatusEffect(xi.effect.THIRD_EYE)
    end

    if attackType == xi.attackType.PHYSICAL and skill:isSingle() == false then
        target:delStatusEffect(xi.effect.THIRD_EYE)
    end

    --handle Third Eye using shadowbehav as a guide
    if attackType == xi.attackType.PHYSICAL and mob:checkThirdEye(target) then
        skill:setMsg(xi.msg.basic.ANTICIPATE)
        return 0
    end

    -- Handle Automaton Analyzer which decreases damage from successive special attacks
    if target:getMod(xi.mod.AUTO_ANALYZER) > 0 then
        local analyzerSkill = target:getLocalVar("analyzer_skill")
        local analyzerHits = target:getLocalVar("analyzer_hits")
        if analyzerSkill == skill:getID() and target:getMod(xi.mod.AUTO_ANALYZER) > analyzerHits then
            -- Successfully mitigating damage at a fixed 40%
            dmg = dmg * 0.6
            analyzerHits = analyzerHits + 1
        else
            target:setLocalVar("analyzer_skill", skill:getID())
            analyzerHits = 0
        end
        target:setLocalVar("analyzer_hits", analyzerHits)
    end

    if dmg < 0 then
        return dmg
    end

    -- Handle Phalanx
    if dmg > 0 then
        dmg = utils.clamp(dmg - target:getMod(xi.mod.PHALANX), 0, 99999)
    end

    if attackType == xi.attackType.MAGICAL then
        dmg = utils.oneforall(target, dmg)

        if dmg < 0 then
            return 0
        end
    end

    dmg = utils.stoneskin(target, dmg)

    if dmg > 0 then
        target:updateEnmityFromDamage(mob, dmg)
        target:handleAfflatusMiseryDamage(dmg)
    end

    return dmg
end

-- returns true if mob attack hit
-- used to stop tp move status effects
xi.mobskills.mobPhysicalHit = function(skill)
    -- if message is not the default. Then there was a miss, shadow taken etc
    return skill:hasMissMsg() == false
end

-- function MobHit()
-- end

-- function MobAoEHit()
-- end

-- function MobMagicHit()
-- end

-- function MobMagicAoEHit()
-- end

xi.mobskills.mobDrainMove = function(mob, target, drainType, drain, attackType, damageType)

    if (target:isUndead() == false) then
        if drainType == xi.mobskills.drainType.MP then
            -- can't go over limited mp
            if (target:getMP() < drain) then
                drain = target:getMP()
            end

            target:delMP(drain)
            mob:addMP(drain)

            return xi.msg.basic.SKILL_DRAIN_MP
        elseif drainType == xi.mobskills.drainType.TP then
            -- can't go over limited tp
            if (target:getTP() < drain) then
                drain = target:getTP()
            end

            target:delTP(drain)
            mob:addTP(drain)

            return xi.msg.basic.SKILL_DRAIN_TP
        elseif drainType == xi.mobskills.drainType.HP then
            -- can't go over limited hp
            if (target:getHP() < drain) then
                drain = target:getHP()
            end

            target:takeDamage(drain, mob, attackType, damageType)
            mob:addHP(drain)

            return xi.msg.basic.SKILL_DRAIN_HP
        end
    else
        -- it's undead so just deal damage
        -- can't go over limited hp
        if (target:getHP() < drain) then
            drain = target:getHP()
        end

        target:takeDamage(drain, mob, attackType, damageType)
        return xi.msg.basic.DAMAGE
    end

    return xi.msg.basic.SKILL_NO_EFFECT
end

xi.mobskills.mobPhysicalDrainMove = function(mob, target, skill, drainType, drain)

    -- If target has Hysteria, no message skip rest
    if mob:hasStatusEffect(xi.effect.HYSTERIA) then
        return xi.msg.basic.NONE
    end

    if (xi.mobskills.mobPhysicalHit(skill)) then
        return xi.mobskills.mobDrainMove(mob, target, drainType, drain)
    end

    return xi.msg.basic.SKILL_MISS
end

xi.mobskills.mobDrainAttribute = function(mob, target, typeEffect, power, tick, duration)
    local positive = nil

    if typeEffect == xi.effect.STR_DOWN then
        positive = xi.effect.STR_BOOST
    elseif typeEffect == xi.effect.DEX_DOWN then
        positive = xi.effect.DEX_BOOST
    elseif typeEffect == xi.effect.AGI_DOWN then
        positive = xi.effect.AGI_BOOST
    elseif typeEffect == xi.effect.VIT_DOWN then
        positive = xi.effect.VIT_BOOST
    elseif typeEffect == xi.effect.MND_DOWN then
        positive = xi.effect.MND_BOOST
    elseif typeEffect == xi.effect.INT_DOWN then
        positive = xi.effect.INT_BOOST
    elseif typeEffect == xi.effect.CHR_DOWN then
        positive = xi.effect.CHR_BOOST
    end

    if positive ~= nil then
        local results = xi.mobskills.mobStatusEffectMove(mob, target, typeEffect, power, tick, duration)

        if results == xi.msg.basic.SKILL_ENFEEB_IS then
            mob:addStatusEffect(positive, power, tick, duration)

            return xi.msg.basic.ATTR_DRAINED
        end

        return xi.msg.basic.SKILL_MISS
    end

    return xi.msg.basic.SKILL_NO_EFFECT
end

xi.mobskills.mobDrainStatusEffectMove = function(mob, target)

    -- If target has Hysteria, no message skip rest
    if mob:hasStatusEffect(xi.effect.HYSTERIA) then
        return xi.msg.basic.NONE
    end

    -- try to drain buff
    local effect = mob:stealStatusEffect(target)

    if (effect ~= 0) then
        return xi.msg.basic.EFFECT_DRAINED
    end

    return xi.msg.basic.SKILL_NO_EFFECT
end

-- Adds a status effect to a target
xi.mobskills.mobStatusEffectMove = function(mob, target, typeEffect, power, tick, duration, subEffect, subPower)

    if mob:hasStatusEffect(xi.effect.HYSTERIA) then
        return xi.msg.basic.NONE
    end

    subEffect = subEffect or 0
    subPower = subPower or 0

    if (target:canGainStatusEffect(typeEffect, power)) then
        local statmod = xi.mod.INT
        local element = mob:getStatusEffectElement(typeEffect)

        local resist = xi.mobskills.applyPlayerResistance(mob, typeEffect, target, mob:getStat(statmod)-target:getStat(statmod), 0, element)

        if (resist >= 0.25) then

            local totalDuration = utils.clamp(duration * resist, 1)
            target:addStatusEffect(typeEffect, power, tick, totalDuration, subEffect, subPower)

            return xi.msg.basic.SKILL_ENFEEB_IS
        end

        return xi.msg.basic.SKILL_MISS -- resist !
    end
    return xi.msg.basic.SKILL_NO_EFFECT -- no effect
end

-- similar to status effect move except, this will not land if the attack missed
xi.mobskills.mobPhysicalStatusEffectMove = function(mob, target, skill, typeEffect, power, tick, duration)

    if (xi.mobskills.mobPhysicalHit(skill)) then
        return xi.mobskills.mobStatusEffectMove(mob, target, typeEffect, power, tick, duration)
    end

    return xi.msg.basic.SKILL_MISS
end

-- similar to statuseffect move except it will only take effect if facing
xi.mobskills.mobGazeMove = function(mob, target, typeEffect, power, tick, duration)
    if target:isFacing(mob) and mob:isInfront(target) then
        return xi.mobskills.mobStatusEffectMove(mob, target, typeEffect, power, tick, duration)
    end
    return xi.msg.basic.SKILL_NO_EFFECT
end

xi.mobskills.mobBuffMove = function(mob, typeEffect, power, tick, duration)
    if mob:hasStatusEffect(xi.effect.HYSTERIA) then
        return xi.msg.basic.NONE
    end

    if mob:addStatusEffect(typeEffect, power, tick, duration) then
        return xi.msg.basic.SKILL_GAIN_EFFECT
    end

    return xi.msg.basic.SKILL_NO_EFFECT
end

xi.mobskills.mobHealMove = function(target, heal)

    local mobHP = target:getHP()
    local mobMaxHP = target:getMaxHP()

    if (mobHP+heal > mobMaxHP) then
        heal = mobMaxHP - mobHP
    end

    target:wakeUp()

    target:addHP(heal)

    return heal
end
