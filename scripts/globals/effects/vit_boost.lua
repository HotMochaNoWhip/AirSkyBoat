-----------------------------------
-- xi.effect.VIT_BOOST
-----------------------------------
require("scripts/globals/status")
-----------------------------------
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    target:addMod(xi.mod.VIT, effect:getPower())
end

effectObject.onEffectTick = function(target, effect)
    -- the effect loses vitality of 1 every 3 ticks depending on the source of the boost
    local boostVIT_effect_size = effect:getPower()
    if (boostVIT_effect_size > 0) then
        effect:setPower(boostVIT_effect_size - 1)
        target:delMod(xi.mod.VIT, 1)
    end
end

effectObject.onEffectLose = function(target, effect)
    local boostVIT_effect_size = effect:getPower()
    if (boostVIT_effect_size > 0) then
        target:delMod(xi.mod.VIT, boostVIT_effect_size)
    end
end

return effectObject
