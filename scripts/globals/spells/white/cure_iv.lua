 -----------------------------------------
-- Spell: Cure IV
-- Restores target's HP.
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/magic")
require("scripts/globals/msg")
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    local divisor = 0
    local constant = 0
    local basepower = 0
    local power = 0
    local basecure = 0
    local final = 0

    local minCure = 270
    if (xi.settings.main.USE_OLD_CURE_FORMULA == true) then
        power = xi.magic.getCurePowerOld(caster)
        divisor = 0.6666
        constant = 165
        if (power > 460) then
            divisor = 6.5
            constant = 354.6666
        elseif (power > 220) then
            divisor = 2
            constant = 275
        end
    else
        power = xi.magic.getCurePower(caster)
        if (power < 200) then
            divisor = 1
            constant = 270
            basepower = 70
        elseif (power < 300) then
            divisor =  2
            constant = 400
            basepower = 200
        elseif (power < 400) then
            divisor = 10/7
            constant = 450
            basepower = 300
        elseif (power < 700) then
            divisor = 2.5
            constant = 520
            basepower = 400
        else
            divisor = 999999
            constant = 640
            basepower = 0
        end
    end
    if xi.magic.isValidHealTarget(caster, target) then
        if (xi.settings.main.USE_OLD_CURE_FORMULA == true) then
            basecure = xi.magic.getBaseCureOld(power, divisor, constant)
        else
            basecure = xi.magic.getBaseCure(power, divisor, constant, basepower)
        end
        final = xi.magic.getCureFinal(caster, spell, basecure, minCure, false)
        if (caster:hasStatusEffect(xi.effect.AFFLATUS_SOLACE) and target:hasStatusEffect(xi.effect.STONESKIN) == false) then
            local solaceStoneskin = 0
            local equippedBody = caster:getEquipID(xi.slot.BODY)
            if (equippedBody == 11186) then
                solaceStoneskin = math.floor(final * 0.30)
            elseif (equippedBody == 11086) then
                solaceStoneskin = math.floor(final * 0.35)
            else
                solaceStoneskin = math.floor(final * 0.25)
            end

            solaceStoneskin = solaceStoneskin * (1 + caster:getMerit(xi.merit.ANIMUS_SOLACE)/100)

            target:addStatusEffect(xi.effect.STONESKIN, solaceStoneskin, 0, 25, 0, 0, 1)
        end
        final = final + (final * (target:getMod(xi.mod.CURE_POTENCY_RCVD)/100))

        --Applying server mods
        final = final * xi.settings.main.CURE_POWER

        local diff = (target:getMaxHP() - target:getHP())
        if (final > diff) then
            final = diff
        end
        target:addHP(final)
        target:wakeUp()
        caster:updateEnmityFromCure(target, final)
    else
        if (target:isUndead()) then
            spell:setMsg(xi.msg.basic.MAGIC_DMG)
            local params = {}
            params.dmg = minCure
            params.multiplier = 1
            params.skillType = xi.skill.HEALING_MAGIC
            params.attribute = xi.mod.MND
            params.hasMultipleTargetReduction = false
            params.diff = caster:getStat(xi.mod.MND)-target:getStat(xi.mod.MND)
            params.bonus = 1.0

            local dmg = xi.magic.calculateMagicDamage(caster, target, spell, params)*0.5
            local resist = xi.magic.applyResistance(caster, target, spell, params)
            dmg = dmg*resist
            dmg = xi.magic.addBonuses(caster, spell, target, dmg)
            dmg = xi.magic.adjustForTarget(target, dmg, spell:getElement())
            dmg = xi.magic.finalMagicAdjustments(caster, target, spell, dmg)
            final = dmg
            target:takeDamage(final, caster, xi.attackType.MAGICAL, xi.damageType.LIGHT)
            target:updateEnmityFromDamage(caster, final)
        elseif (caster:getObjType() == xi.objType.PC) then
            spell:setMsg(xi.msg.basic.MAGIC_NO_EFFECT)
        else
            -- e.g. monsters healing themselves.
            if (xi.settings.main.USE_OLD_CURE_FORMULA == true) then
                basecure = xi.magic.getBaseCureOld(power, divisor, constant)
            else
                basecure = xi.magic.getBaseCure(power, divisor, constant, basepower)
            end
            final = xi.magic.getCureFinal(caster, spell, basecure, minCure, false)
            local diff = (target:getMaxHP() - target:getHP())
            if (final > diff) then
                final = diff
            end
            target:addHP(final)
        end
    end

    local mpBonusPercent = (final*caster:getMod(xi.mod.CURE2MP_PERCENT))/100
    if (mpBonusPercent > 0) then
        caster:addMP(mpBonusPercent)
    end

    return final
end

return spellObject
