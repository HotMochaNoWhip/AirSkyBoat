-----------------------------------
-- ID: 14855
-- Item: Mist Mitts
-- Item Effect: Evasion Boost
-----------------------------------
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------
local itemObject = {}

itemObject.onItemCheck = function(target)
    local effect = target:getStatusEffect(xi.effect.EVASION_BOOST)
    if effect ~= nil and effect:getSubType() == 14855 then
        target:delStatusEffect(xi.effect.EVASION_BOOST)
    end
    return 0
end

itemObject.onItemUse = function(target)
    if (not target:hasStatusEffect(xi.effect.EVASION_BOOST)) then
        target:addStatusEffect(xi.effect.EVASION_BOOST, 15, 0, 180, 14855)
    else
        target:messageBasic(xi.msg.basic.NO_EFFECT)
    end
end

return itemObject
