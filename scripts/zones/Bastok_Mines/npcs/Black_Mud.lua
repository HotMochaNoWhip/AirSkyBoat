-----------------------------------
-- Area: Bastok Mines
--  NPC: Black Mud
-- Starts & Finishes Quest: Drachenfall
-----------------------------------
require("scripts/globals/pathfind")
-----------------------------------
local entity = {}

local path =
{
    { x = 35.243, y = 7.000, z = -1.829, wait = 4000 },
    { x = 89.659, y = 7.000, z = -0.181, wait = 4000 },
}

entity.onSpawn = function(npc)
    npc:initNpcAi()
    npc:setPos(xi.path.first(path))
    npc:pathThrough(path, xi.path.flag.PATROL)
end

entity.onTrade = function(player, npc, trade)
end

entity.onTrigger = function(player, npc)
end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)
end

return entity
