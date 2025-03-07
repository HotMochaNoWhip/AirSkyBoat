-----------------------------------
-- Ability: Ice Shot
-- Consumes a Ice Card to enhance ice-based debuffs. Deals ice-based magic damage
-- Frost Effect: Enhanced DoT and AGI-
-----------------------------------
require("scripts/globals/ability")
require("scripts/globals/jobpoints")
require("scripts/globals/magic")
require("scripts/globals/status")
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    --ranged weapon/ammo: You do not have an appropriate ranged weapon equipped.
    --no card: <name> cannot perform that action.
    if player:getWeaponSkillType(xi.slot.RANGED) ~= xi.skill.MARKSMANSHIP or player:getWeaponSkillType(xi.slot.AMMO) ~= xi.skill.MARKSMANSHIP then
        return 216, 0
    end
    if player:hasItem(2177, 0) or player:hasItem(2974, 0) then
        return 0, 0
    else
        return 71, 0
    end
end

abilityObject.onUseAbility = function(player, target, ability, action)
    local params = {}
    params.includemab = true
    local dmg = (2 * (player:getRangedDmg() + player:getAmmoDmg()) + player:getMod(xi.mod.QUICK_DRAW_DMG)) * (1 + player:getMod(xi.mod.QUICK_DRAW_DMG_PERCENT) / 100)
    dmg = dmg + 2 * player:getJobPointLevel(xi.jp.QUICK_DRAW_EFFECT)
    dmg  = xi.magic.addBonusesAbility(player, xi.magic.ele.ICE, target, dmg, params)
    local bonusAcc = player:getStat(xi.mod.AGI) / 2 + player:getMerit(xi.merit.QUICK_DRAW_ACCURACY) + player:getMod(xi.mod.QUICK_DRAW_MACC)
    dmg = dmg * xi.magic.applyResistanceAbility(player, target, xi.magic.ele.ICE, xi.skill.NONE, bonusAcc)
    dmg = xi.magic.adjustForTarget(target, dmg, xi.magic.ele.ICE)

    params.targetTPMult = 0 -- Quick Draw does not feed TP
    dmg = takeAbilityDamage(target, player, params, true, dmg, xi.attackType.MAGICAL, xi.damageType.ICE, xi.slot.RANGED, 1, 0, 0, 0, action, nil)

    if dmg > 0 then
        local effects = {}
        local frost = target:getStatusEffect(xi.effect.FROST)
        if frost ~= nil then
            table.insert(effects, frost)
        end

        local threnody = target:getStatusEffect(xi.effect.THRENODY)
        if threnody ~= nil and threnody:getSubPower() == xi.mod.WIND_MEVA then
            table.insert(effects, threnody)
        end

        local paralyze = target:getStatusEffect(xi.effect.PARALYSIS)
        if paralyze ~= nil then
            table.insert(effects, paralyze)
        end

        if #effects > 0 then
            local effect = effects[math.random(#effects)]
            local duration = effect:getDuration()
            local startTime = effect:getStartTime()
            local tick = effect:getTick()
            local power = effect:getPower()
            local subpower = effect:getSubPower()
            local tier = effect:getTier()
            local effectId = effect:getType()
            local subId = effect:getSubType()
            power = power * 1.2
            target:delStatusEffectSilent(effectId)
            target:addStatusEffect(effectId, power, tick, duration, subId, subpower, tier)
            local newEffect = target:getStatusEffect(effectId)
            newEffect:setStartTime(startTime)
        end
    end

    local _ = player:delItem(2177, 1) or player:delItem(2974, 1)

    target:updateClaim(player)
    return dmg
end

return abilityObject
