-----------------------------------
-- Spell: Disseverment
-- Delivers a fivefold attack. Additional effect: Poison. Accuracy varies with TP
-- Spell cost: 74 MP
-- Monster Type: Luminians
-- Spell Type: Physical (Piercing)
-- Blue Magic Points: 5
-- Stat Bonus: INT+1, MND-1
-- Level: 72
-- Casting Time: 0.5 seconds
-- Recast Time: 32.75 seconds
-- Skillchain Element(s): Distortion (can open/close Darkness with Gravitation WSs and spells)
-- Combos: Accuracy Bonus
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
    local params = {}
    -- This data should match information on http://wiki.ffxiclopedia.org/wiki/Calculating_Blue_Magic_Damage
    params.tpmod = TPMOD_ACC
    params.attackType = xi.attackType.PHYSICAL
    params.damageType = xi.damageType.PIERCING
    params.scattr = SC_DISTORTION
    params.numhits = 5
    params.multiplier = 1.5
    params.tp150 = 0.8
    params.tp300 = 1.0
    params.azuretp = 1.0
    params.duppercap = 100 -- D upper >=69
    params.str_wsc = 0.2
    params.dex_wsc = 0.2
    params.vit_wsc = 0.0
    params.agi_wsc = 0.0
    params.int_wsc = 0.0
    params.mnd_wsc = 0.0
    params.chr_wsc = 0.0
    local damage = BluePhysicalSpell(caster, target, spell, params)
    damage = BlueFinalAdjustments(caster, target, spell, damage, params)

    local poison = target:getStatusEffect(xi.effect.POISON)
    local chance = math.random()
    if (chance < 0.95 and poison == nil) then
        local power = (caster:getMainLvl()/5) + 3 -- from http://wiki.ffxiclopedia.org/wiki/Disseverment
        target:addStatusEffect(xi.effect.POISON, power, 3, 180) -- for 180secs
    end

    return damage
end

return spellObject
