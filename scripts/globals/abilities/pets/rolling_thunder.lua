-----------------------------------
--
-----------------------------------
require("scripts/globals/mobskills")
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/utils")
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onPetAbility = function(target, pet, skill, summoner)
    local bonusTime = utils.clamp(summoner:getSkillLevel(xi.skill.SUMMONING_MAGIC) - 300, 0, 200)
    local duration = 120 + bonusTime

    local magicskill = utils.getSkillLvl(1, target:getMainLvl())

    local potency = 3 + ((6*magicskill)/100)
    if (magicskill>200) then
        potency = 5 + ((5*magicskill)/100)
    end

    local typeEffect = xi.effect.ENTHUNDER

    skill:setMsg(xi.mobskills.mobBuffMove(target, typeEffect, potency, 0, duration))

    return typeEffect
end

return abilityObject
