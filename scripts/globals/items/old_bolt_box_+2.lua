-----------------------------------
-- ID: 5280
-- Old Bolt Box +2
-- When used, you will obtain one partial stack of Dogbolt +2
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
    target:addItem(18191, math.random(99))
end

return itemObject
