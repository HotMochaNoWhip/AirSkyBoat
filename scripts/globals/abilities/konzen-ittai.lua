-----------------------------------
-- Ability: Konzen-Ittai
-- Readies target for a skillchain.
-- Obtained: Samurai Level 65
-- Recast Time: 0:03:00
-- Duration: 1:00 or until next Weapon Skill
-----------------------------------
require("scripts/globals/weaponskills")
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    if (player:getAnimation() ~= 1) then
        return xi.msg.basic.REQUIRES_COMBAT, 0
    else
        return 0, 0
    end
end

abilityObject.onUseAbility = function(player, target, ability, action)
    if (not target:hasStatusEffect(xi.effect.CHAINBOUND, 0) and not target:hasStatusEffect(xi.effect.SKILLCHAIN, 0)) then
        target:addStatusEffectEx(xi.effect.CHAINBOUND, 0, 2, 0, 5, 0, 1)
    else
        ability:setMsg(xi.msg.basic.JA_NO_EFFECT)
    end
    local skill = player:getWeaponSkillType(xi.slot.MAIN)
    local anim = 36
    if skill <= 1 then
        anim = 37
    elseif skill <= 3 then
        anim = 36
    elseif skill == 4 then
        anim = 41
    elseif skill == 5 then
        anim = 28
    elseif skill <= 7 then
        anim = 40
    elseif skill == 8 then
        anim = 42
    elseif skill == 9 then
        anim = 43
    elseif skill == 10 then
        anim = 44
    elseif skill == 11 then
        anim = 39
    elseif skill == 12 then
        anim = 45
    else
        anim = 36
    end
    action:setAnimation(target:getID(), anim)
    action:speceffect(target:getID(), 1)
    return 0
end

return abilityObject
