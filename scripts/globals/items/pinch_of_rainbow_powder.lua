-----------------------------------
-- ID: 5362
-- Rainbow Powder
-- When applied, it makes things invisible.
-- Removed Medicated status as per https://www.bg-wiki.com/ffxi/Rainbow_Powder
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
-----------------------------------
local itemObject = {}

itemObject.onItemCheck = function(target)
    return 0
end

itemObject.onItemUse = function(target)
    local duration = 180
    if target:hasStatusEffect(xi.effect.INVISIBLE) then
       target:delStatusEffect(xi.effect.INVISIBLE)
    end

    duration = duration + target:getMod(xi.mod.INVISIBLE_DURATION)

    target:addStatusEffect(xi.effect.INVISIBLE, 1, 10, math.floor(600 * xi.settings.main.SNEAK_INVIS_DURATION_MULTIPLIER))
end

return itemObject
