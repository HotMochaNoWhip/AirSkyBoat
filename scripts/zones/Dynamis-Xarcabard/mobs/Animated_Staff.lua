-----------------------------------
-- Area: Dynamis - Xarcabard
--  Mob: Animated Staff
-----------------------------------
require("scripts/globals/status")
local ID = require("scripts/zones/Dynamis-Xarcabard/IDs")
-----------------------------------
local entity = {}

entity.onMobEngaged = function(mob, target)

    if (mob:getAnimationSub() == 3) then
        SetDropRate(115, 1582, 1000)
    else
        SetDropRate(115, 1582, 0)
    end

    target:showText(mob, ID.text.ANIMATED_STAFF_DIALOG)
end

entity.onMobFight = function(mob, target)
    -- TODO: add battle dialog
end

entity.onMobDisengage = function(mob)
    mob:showText(mob, ID.text.ANIMATED_STAFF_DIALOG+2)
end

entity.onMobDeath = function(mob, player, optParams)
    player:showText(mob, ID.text.ANIMATED_STAFF_DIALOG+1)
end

return entity
