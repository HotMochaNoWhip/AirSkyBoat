-----------------------------------
-- Spell: Threnody II - xi.mod.EARTH_MEVA
-----------------------------------
require("scripts/globals/status")
require("scripts/globals/magic")
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster,target,spell)
    return 0
end

spellObject.onSpellCast = function(caster,target,spell)
    return xi.magic.handleThrenody(caster, target, spell, 160, 90, xi.mod.EARTH_MEVA)
end

return spellObject
