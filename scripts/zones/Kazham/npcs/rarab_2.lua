-----------------------------------
-- Area: Kazham
--  NPC: Rarab
-- Nonstandard NPC w/o Nametag
-----------------------------------
require("scripts/globals/pathfind")
-----------------------------------
local entity = {}

local path =
{
    { x = 97.211, y = -14.000, z = -101.790, wait = 3000 },
    { x = 103.751, z = -100.245, wait = 3000 },
    { x = 100.553, z = -101.574, wait = 3000 },
    { x = 102.540, z = -105.244 },
    { x = 99.715, z = -99.986, wait = 6000 },
    { x = 96.482, z = -102.745, wait = 6000 },
}

entity.onSpawn = function(npc)
    npc:initNpcAi()
    npc:setPos(xi.path.first(path))
    npc:pathThrough(path, bit.bor(xi.path.flag.PATROL, xi.path.flag.RUN))
end

return entity
