-----------------------------------
-- Zone: Crawlers_Nest (197)
-----------------------------------
local ID = require('scripts/zones/Crawlers_Nest/IDs')
require('scripts/globals/conquest')
require('scripts/globals/treasure')
-----------------------------------
local zoneObject = {}

zoneObject.onInitialize = function(zone)
    if xi.settings.main.ENABLE_WOTG == 1 then
        UpdateNMSpawnPoint(ID.mob.DYNAST_BEETLE)
        GetMobByID(ID.mob.DYNAST_BEETLE):setRespawnTime(math.random(5400, 7200))
    end

    xi.treasure.initZone(zone)
end

zoneObject.onZoneIn = function(player, prevZone)
    local cs = -1

    if player:getXPos() == 0 and player:getYPos() == 0 and player:getZPos() == 0 then
        player:setPos(380.617, -34.61, 4.581, 59)
    end

    return cs
end

zoneObject.onConquestUpdate = function(zone, updatetype)
    xi.conq.onConquestUpdate(zone, updatetype)
end

zoneObject.onRegionEnter = function(player, region)
end

zoneObject.onEventUpdate = function(player, csid, option)
end

zoneObject.onEventFinish = function(player, csid, option)
end

return zoneObject
