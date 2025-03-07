-----------------------------------------
-- ID: 18164
-- Item: Antarctic Wind
-- Additional Effect: Removes Genbu's Water Damage
-----------------------------------------
require("scripts/globals/status")
-----------------------------------------
local itemObject = {}

itemObject.onAdditionalEffect = function(player, target, damage)
    if not target:isMob() then
        return 1
    end

    if (target:getFamily() == 277) then
        target:setMobMod(xi.mobMod.ADD_EFFECT, 0)
    end

    return 0, 0, 0
end

return itemObject
