-----------------------------------
-- ID: 5829
-- Item: Lucid Ether III
-- Item Effect: Restores 1000 MP
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/msg")
-----------------------------------
local itemObject = {}

itemObject.onItemCheck = function(target)
    if target:getMP() == target:getMaxMP() then
        return xi.msg.basic.ITEM_UNABLE_TO_USE
    end
    return 0
end

itemObject.onItemUse = function(target)
    target:messageBasic(xi.msg.basic.RECOVERS_MP, 0, target:addMP(1000*xi.settings.main.ITEM_POWER))
end

return itemObject
