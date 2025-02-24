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
    if mob:getHPP() > 60 or mob:getAnimationSub() ~= 4 then
        return 1
    end
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local dmgmod = 1
    local bombTossHPP = skill:getMobHPP() / 100

    -- Razon - ENM: Fire in the Sky
    if mob:getHPP() <= 66 and mob:getPool() == 3333 then
        bombTossHPP = 0
    end

    local info = xi.mobskills.mobMagicalMove(mob, target, skill, mob:getWeaponDmg()*18*bombTossHPP, xi.magic.ele.FIRE, dmgmod, xi.mobskills.magicalTpBonus.MAB_BONUS, 1)
    local dmg = xi.mobskills.mobFinalAdjustments(info.dmg, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS)

    mob:setAnimationSub(5)

    target:takeDamage(dmg, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)
    return dmg
end

return mobskillObject
