-----------------------------------
-- Chaotic Strike M=9 , 2
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/summon")
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onPetAbility = function(target, pet, skill)
    local numhits = 3
    local accmod = 1
    local dmgmod = 4
    local dmgmodsubsequent = 2
    local totaldamage = 0
    local wSC = (pet:getStat(xi.mod.STR) * 0.20) + (pet:getStat(xi.mod.INT) * 0.20)

    local damage = xi.summon.avatarPhysicalMove(pet, target, skill, numhits, accmod, dmgmod, dmgmodsubsequent, xi.mobskills.magicalTpBonus.NO_EFFECT, 1, 2, 3, wSC)
    totaldamage = xi.summon.avatarFinalAdjustments(damage.dmg, pet, skill, target, xi.attackType.PHYSICAL, xi.damageType.BLUNT, numhits)
    target:addStatusEffect(xi.effect.STUN, 1, 0, 2)
    target:takeDamage(totaldamage, pet, xi.attackType.PHYSICAL, xi.damageType.BLUNT)
    target:updateEnmityFromDamage(pet, totaldamage)
    return totaldamage
end

return abilityObject
