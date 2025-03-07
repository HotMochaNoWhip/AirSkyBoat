-----------------------------------
-- Spell: Radiant Breath
-- Deals light damage to enemies within a fan-shaped area of effect originating from the caster. Additional effect: Slow and Silence.
-- Spell cost: 116 MP
-- Monster Type: Wyverns
-- Spell Type: Magical (Light)
-- Blue Magic Points: 4
-- Stat Bonus: CHR+1, HP+5
-- Level: 54
-- Casting Time: 5.25 seconds
-- Recast Time: 33.75 seconds
-- Magic Bursts on: Transfixion, Fusion, Light
-- Combos: None
-----------------------------------
require("scripts/globals/bluemagic")
require("scripts/globals/status")
require("scripts/globals/magic")
-----------------------------------
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return 0
end

spellObject.onSpellCast = function(caster, target, spell)
    local multi = 2.90
    if (caster:hasStatusEffect(xi.effect.AZURE_LORE)) then
        multi = multi + 0.50
    end

    local params = {}
    -- This data should match information on http://wiki.ffxiclopedia.org/wiki/Calculating_Blue_Magic_Damage
    params.attackType = xi.attackType.BREATH
    params.damageType = xi.damageType.LIGHT
    params.multiplier = multi
    params.tMultiplier = 1.5
    params.duppercap = 69
    params.str_wsc = 0.0
    params.dex_wsc = 0.0
    params.vit_wsc = 0.0
    params.agi_wsc = 0.0
    params.int_wsc = 0.0
    params.mnd_wsc = 0.3
    params.chr_wsc = 0.0
    params.diff = caster:getStat(xi.mod.INT) - target:getStat(xi.mod.INT)
    params.attribute = xi.mod.INT
    params.skillType = xi.skill.BLUE_MAGIC
    params.bonus = 1.0

    local resist = xi.magic.applyResistance(caster, target, spell, params)
    local damage = BlueMagicalSpell(caster, target, spell, params, MND_BASED)
    damage = BlueFinalAdjustments(caster, target, spell, damage, params)

    if (damage > 0 and resist > 0.3) then
    local typeEffect = xi.effect.SLOW
        target:delStatusEffect(typeEffect)
        target:addStatusEffect(typeEffect, 3500, 0, getBlueEffectDuration(caster, resist, typeEffect))
    end

    if (damage > 0 and resist > 0.3) then
        target:delStatusEffect(xi.effect.SILENCE)
        target:addStatusEffect(xi.effect.SILENCE, 25, 0, getBlueEffectDuration(caster, resist, xi.effect.SILENCE))
    end

    return damage
end

return spellObject
