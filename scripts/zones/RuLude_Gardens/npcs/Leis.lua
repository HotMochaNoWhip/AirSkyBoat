-----------------------------------
-- Area: Ru'Lude Gardens
--  NPC: Leis
-----------------------------------
require("scripts/globals/pathfind")
-----------------------------------
local entity = {}

local path =
{

    { x = -8.826, y = 1.996, z = 132.537, rotation = 64, wait = 8000 },
    { x = -8.294, y = 1.996, z = 137.101, rotation = 0, wait = 8000 },
    { x = -8.826, y = 1.996, z = 132.537, rotation = 64, wait = 8000 },
    { x = -12.483, y = 1.984, z = 136.894, rotation = 128, wait = 8000 },
    { x = -8.294, y = 1.996, z = 137.101, rotation = 0, wait = 8000 },
    { x = -12.483, y = 1.984, z = 136.894, rotation = 128, wait = 8000 },
}

entity.onSpawn = function(npc)
    npc:initNpcAi()
    npc:setPos(xi.path.first(path))
    npc:pathThrough(path, xi.path.flag.PATROL)
end

entity.onTrade = function(player, npc, trade)
end

entity.onTrigger = function(player, npc)
    player:startEvent(119)
end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)
end

return entity
