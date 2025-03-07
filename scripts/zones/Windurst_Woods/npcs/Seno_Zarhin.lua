-----------------------------------
-- Area: Windurst Woods
--  NPC: Seno Zarhin
-----------------------------------
require("scripts/globals/pathfind")
-----------------------------------
local entity = {}

local path =
{
    { x = -31.412, y = 2.667, z = -46.021 },
    { x = -36.695, y = 2.906, z = -49.078 },
    { x = -37.131, y = 2.847, z = -49.978 },
    { x = -37.214, y = 2.836, z = -50.277 },
    { x = -38.365, y = 2.991, z = -55.456 },
    { x = -37.214, y = 2.836, z = -50.277 },
    { x = -37.131, y = 2.847, z = -49.978 },
    { x = -36.695, y = 2.906, z = -49.078 },
}

entity.onSpawn = function(npc)
    npc:initNpcAi()
    npc:setPos(xi.path.first(path))
    npc:pathThrough(path, xi.path.flag.PATROL)
end

entity.onTrade = function(player, npc, trade)
end

entity.onTrigger = function(player, npc)
    player:startEvent(417)
end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)
end

return entity
