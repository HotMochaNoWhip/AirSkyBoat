-----------------------------------
-- Spell: Gravity
-----------------------------------
require("scripts/globals/magic")
require("scripts/globals/msg")
require("scripts/globals/status")
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    -- Pull base stats.
    local dINT = caster:getStat(xi.mod.INT) - target:getStat(xi.mod.INT)

    local power = 20

    -- Duration, including resistance.  Unconfirmed.
    local duration = xi.magic.calculateDuration(120, spell:getSkillType(), spell:getSpellGroup(), caster, target)

    local params = {}
    params.diff = dINT
    params.skillType = xi.skill.ENFEEBLING_MAGIC
    params.bonus = 0
    params.effect = xi.effect.WEIGHT
    local resist = xi.magic.applyResistanceEffect(caster, target, spell, params)

    if resist >= 0.5 then --Do it!
        local resduration = duration * resist

        resduration = xi.magic.calculateBuildDuration(target, duration, params.effect, caster)

        if resduration == 0 then
            spell:setMsg(xi.msg.basic.NONE)
        elseif target:addStatusEffect(params.effect, power, 0, resduration) then
            spell:setMsg(xi.msg.basic.MAGIC_ENFEEB_IS)
        else
            spell:setMsg(xi.msg.basic.MAGIC_NO_EFFECT)
        end
    else
        spell:setMsg(xi.msg.basic.MAGIC_RESIST_2)
    end

    return params.effect
end

return spellObject
