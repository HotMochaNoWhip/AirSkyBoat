-----------------------------------
-- ID: 5270
-- Old Quiver
-- When used, you will obtain one partial stack of Crude Arrows
-----------------------------------
require("scripts/globals/msg")
-----------------------------------
local itemObject = {}

itemObject.onItemCheck = function(target)
    local result = 0
    if target:getFreeSlotsCount() == 0 then
        result = xi.msg.basic.ITEM_NO_USE_INVENTORY
    end
    return result
end

itemObject.onItemUse = function(target)
    target:addItem(18181, math.random(99))
end

return itemObject
