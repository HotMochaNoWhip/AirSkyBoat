-----------------------------------
-- Zone: Bibiki_Bay (4)
-----------------------------------
local ID = require('scripts/zones/Bibiki_Bay/IDs')
require('scripts/globals/chocobo_digging')
require('scripts/globals/manaclipper')
require('scripts/globals/zone')
-----------------------------------
local zoneObject = {}

zoneObject.onChocoboDig = function(player, precheck)
    return xi.chocoboDig.start(player, precheck)
end

zoneObject.onInitialize = function(zone)
    zone:registerRegion(1,  474, -10,  667,  511, 10,  708) -- Manaclipper while docked at Sunset Docks
    zone:registerRegion(2, -410, -10, -385, -371, 10, -343) -- Manaclipper while docked at Purgonorgo Isle
end

zoneObject.onZoneIn = function(player, prevZone)
    local cs = -1

    if player:getXPos() == 0 and player:getYPos() == 0 and player:getZPos() == 0 then
        if prevZone == xi.zone.MANACLIPPER then
            cs = xi.manaclipper.onZoneIn(player)
        else
            player:setPos(669.917, -23.138, 911.655, 111)
        end
    end

    return cs
end

zoneObject.onConquestUpdate = function(zone, updatetype)
    xi.conq.onConquestUpdate(zone, updatetype)
end

zoneObject.onGameDay = function()
    SetServerVariable("[DIG]ZONE4_ITEMS", 0)
end

zoneObject.onRegionEnter = function(player, region)
    xi.manaclipper.aboard(player, region:GetRegionID(), true)
end

zoneObject.onRegionLeave = function(player, region)
    xi.manaclipper.aboard(player, region:GetRegionID(), false)
end

zoneObject.onTransportEvent = function(player, transport)
    xi.manaclipper.onTransportEvent(player, transport)
end

zoneObject.onEventUpdate = function(player, csid, option)
end

zoneObject.onEventFinish = function(player, csid, option)
    if csid == 12 then
        player:startEvent(10) -- arrive at Sunset Docks CS
    elseif csid == 13 then
        player:startEvent(11) -- arrive at Purgonorgo Isle CS
    elseif csid == 14 or csid == 16 then
        player:setPos(0, 0, 0, 0, xi.zone.MANACLIPPER)
    end
end

return zoneObject
