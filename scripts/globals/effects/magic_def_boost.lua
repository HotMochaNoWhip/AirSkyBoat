-----------------------------------
-- xi.effect.MAGIC_DEF_BOOST
-----------------------------------
require("scripts/globals/status")
-----------------------------------
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    if (effect:getPower()>100) then
        effect:setPower(50)
    end
    target:addMod(xi.mod.MDEF, effect:getPower())
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    target:delMod(xi.mod.MDEF, effect:getPower())
end

return effectObject
