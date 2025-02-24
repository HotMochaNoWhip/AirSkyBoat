-----------------------------------
-- Area: Dynamis - Xarcabard
--  Mob: Animated Tabar
-----------------------------------
require("scripts/globals/status")
local ID = require("scripts/zones/Dynamis-Xarcabard/IDs")
-----------------------------------
local entity = {}

entity.onMobEngaged = function(mob, target)

    if (mob:getAnimationSub() == 3) then
        SetDropRate(116, 1575, 1000)
    else
        SetDropRate(116, 1575, 0)
    end

    target:showText(mob, ID.text.ANIMATED_TABAR_DIALOG)
end

entity.onMobFight = function(mob, target)
    -- TODO: add battle dialog
end

entity.onMobDisengage = function(mob)
    mob:showText(mob, ID.text.ANIMATED_TABAR_DIALOG+2)
end

entity.onMobDeath = function(mob, player, optParams)
    player:showText(mob, ID.text.ANIMATED_TABAR_DIALOG+1)
end

return entity
