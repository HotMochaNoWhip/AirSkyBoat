-----------------------------------
-- Spell: Frost
-- Deals ice damage that lowers an enemy's agility and gradually reduces its HP.
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/magic")
require("scripts/globals/msg")
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)

    if (target:getStatusEffect(xi.effect.BURN) ~= nil) then
        spell:setMsg(xi.msg.basic.MAGIC_NO_EFFECT) -- no effect
    else
        -- local dINT = caster:getStat(xi.mod.INT)-target:getStat(xi.mod.INT)
        local params = {}
        params.diff = nil
        params.attribute = xi.mod.INT
        params.skillType = xi.skill.ELEMENTAL_MAGIC
        params.bonus = 0
        params.effect = nil
        local resist = xi.magic.applyResistance(caster, target, spell, params)
        if (resist <= 0.125) then
            spell:setMsg(xi.msg.basic.MAGIC_RESIST)
        else
            if (target:getStatusEffect(xi.effect.CHOKE) ~= nil) then
                target:delStatusEffect(xi.effect.CHOKE)
            end
            local sINT = caster:getStat(xi.mod.INT)
            local DOT = xi.magic.getElementalDebuffDOT(sINT)
            local effect = target:getStatusEffect(xi.effect.FROST)
            local noeffect = false
            if (effect ~= nil) then
                if (effect:getPower() >= DOT) then
                    noeffect = true
                end
            end
            if (noeffect) then
                spell:setMsg(xi.msg.basic.MAGIC_NO_EFFECT) -- no effect
            else
                if (effect ~= nil) then
                    target:delStatusEffect(xi.effect.FROST)
                end
                spell:setMsg(xi.msg.basic.MAGIC_ENFEEB)
                local duration = math.floor(xi.settings.main.ELEMENTAL_DEBUFF_DURATION * resist)
                duration = duration + caster:getMerit(xi.merit.ELEMENTAL_DEBUFF_DURATION)

                local mbonus = caster:getMerit(xi.merit.ELEMENTAL_DEBUFF_EFFECT)
                DOT = DOT + mbonus/2 -- Damage
                target:addStatusEffect(xi.effect.FROST, DOT, 3, duration)
            end
        end
    end

    return xi.effect.FROST

end

return spellObject
