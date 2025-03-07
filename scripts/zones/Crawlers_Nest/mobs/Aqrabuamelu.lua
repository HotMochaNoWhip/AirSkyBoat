-----------------------------------
-- Area: Crawlers' Nest
--   NM: Aqrabuamelu
-----------------------------------
require("scripts/globals/hunts")
require("scripts/globals/status")
require("scripts/globals/magic")
require("scripts/globals/msg")
-----------------------------------
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.AUTO_SPIKES, 1)
    mob:addStatusEffect(xi.effect.ICE_SPIKES, 45, 0, 0)
    mob:getStatusEffect(xi.effect.ICE_SPIKES):setFlag(xi.effectFlag.DEATH)
end

entity.onSpikesDamage = function(mob, target, damage)
    local INT_diff = mob:getStat(xi.mod.INT) - target:getStat(xi.mod.INT)

    if INT_diff > 20 then
        INT_diff = 20 + (INT_diff - 20) * 0.5 -- INT above 20 is half as effective.
    end

    local dmg = (damage + INT_diff) * 0.5 -- INT adjustment and base damage averaged together.
    local params = {}
    params.bonusmab = 0
    params.includemab = false
    dmg = xi.magic.addBonusesAbility(mob, xi.magic.ele.ICE, target, dmg, params)
    dmg = dmg * xi.magic.applyResistanceAddEffect(mob, target, xi.magic.ele.ICE, 0)
    dmg = xi.magic.adjustForTarget(target, dmg, xi.magic.ele.ICE)
    dmg = xi.magic.finalMagicNonSpellAdjustments(mob, target, xi.magic.ele.ICE, dmg)

    if dmg < 0 then
        dmg = 0
    end

    return xi.subEffect.ICE_SPIKES, xi.msg.basic.SPIKES_EFFECT_DMG, dmg

end

entity.onMobDeath = function(mob, player, optParams)
    xi.hunts.checkHunt(mob, player, 238)
end

entity.onMobDespawn = function(mob)
    UpdateNMSpawnPoint(mob:getID())
    mob:setRespawnTime(math.random(7200, 7800)) -- 120 to 130 min
end

return entity
