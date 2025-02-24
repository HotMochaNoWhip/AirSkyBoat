-----------------------------------
-- Metalid Body
--
-- Gives the effect of "Stoneskin."
-- Type: Magical
-----------------------------------
require("scripts/globals/mobskills")
require("scripts/globals/settings")
require("scripts/globals/status")
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:hasStatusEffect(xi.effect.STONESKIN) then
        return 1
    else
        return 0
    end
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local power = 25 -- ffxiclopedia claims its always 25 on the crabs page. Tested on wootzshell in mt zhayolm..
    --[[
    if (mob:isNM()) then
        power = ???  Betting NMs aren't 25 but I don't have data..
    end
    ]]
    skill:setMsg(xi.mobskills.mobBuffMove(mob, xi.effect.STONESKIN, power, 0, 300))
    return xi.effect.STONESKIN
end

return mobskillObject
