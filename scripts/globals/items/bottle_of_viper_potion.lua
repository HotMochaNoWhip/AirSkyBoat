-----------------------------------
-- ID: 4157
-- Item: Viper Potion
-- Item Effect: Removes 300 HP over 3 mins
-----------------------------------
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------
local itemObject = {}

itemObject.onItemCheck = function(target)
    return 0
end

itemObject.onItemUse = function(target)
    if (not target:hasStatusEffect(xi.effect.POISON)) then
        target:addStatusEffect(xi.effect.POISON, 5, 3, 180)
    else
        target:messageBasic(xi.msg.basic.NO_EFFECT)
    end
end

return itemObject
