-----------------------------------
-- Healing Breeze
--
-- Description: Restores HP for party members within area of effect.
-- Type: Magical (Wind)
--
--
-----------------------------------
require("scripts/globals/mobskills")
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local potency = skill:getParam()

    if (potency == 0) then
        potency = 12
    end

    potency = potency - math.random(0, potency/4)

    skill:setMsg(xi.msg.basic.SELF_HEAL)

    return xi.mobskills.mobHealMove(target, target:getMaxHP() * potency / 100)
end

return mobskillObject
