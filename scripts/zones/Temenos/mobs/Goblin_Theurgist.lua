-----------------------------------
-- Area: Temenos N T
--  Mob: Goblin Theurgist
-----------------------------------
mixins = { require("scripts/mixins/job_special") }
local ID = require("scripts/zones/Temenos/IDs")
-----------------------------------
local entity = {}

entity.onMobEngaged = function(mob, target)
    GetMobByID(ID.mob.TEMENOS_N_MOB[7]):updateEnmity(target)
    GetMobByID(ID.mob.TEMENOS_N_MOB[7]+1):updateEnmity(target)
    GetMobByID(ID.mob.TEMENOS_N_MOB[7]+3):updateEnmity(target)
end

entity.onMobDeath = function(mob, player, optParams)
    if optParams.isKiller or optParams.noKiller then
        if GetMobByID(ID.mob.TEMENOS_N_MOB[7]):isDead() and GetMobByID(ID.mob.TEMENOS_N_MOB[7]+1):isDead() and
            GetMobByID(ID.mob.TEMENOS_N_MOB[7]+2):isDead() and GetMobByID(ID.mob.TEMENOS_N_MOB[7]+3):isDead() and
            GetMobByID(ID.mob.TEMENOS_N_MOB[7]+4):isDead()
        then
            GetNPCByID(ID.npc.TEMENOS_N_CRATE[7]):setStatus(xi.status.NORMAL)
        end
    end
end

return entity
