-----------------------------------
-- Self-Destruct
-- Bomb Cluster Self Destruct - 3 Bombs up
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/mobskills")
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if (mob:getHPP() > 60 or mob:getAnimationSub() ~= 4) and math.random() > .2 then -- 20% chance for all bombs to explode
        return 1
    end
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local dmgmod = 1

    local info = xi.mobskills.mobMagicalMove(mob, target, skill, mob:getWeaponDmg()*math.random(10, 18), xi.magic.ele.NONE, dmgmod, xi.mobskills.magicalTpBonus.NO_EFFECT)
    local dmg = xi.mobskills.mobFinalAdjustments(info.dmg, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.ELEMENTAL, xi.mobskills.shadowBehavior.IGNORE_SHADOWS)
    mob:setHP(0)
    target:takeDamage(dmg, mob, xi.attackType.MAGICAL, xi.damageType.ELEMENTAL)
    return dmg
end

return mobskillObject
