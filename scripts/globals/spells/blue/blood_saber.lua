-----------------------------------
-- Spell: Blood Saber
-- Steals HP from enemies within range. Ineffective against undead
-- Spell cost: 25 MP
-- Monster Type: Undead
-- Spell Type: Magical (Dark)
-- Blue Magic Points: 2
-- Stat Bonus: HP-5, MP+5
-- Level: 48
-- Casting Time: 4 seconds
-- Recast Time: 90 seconds
-- Magic Bursts on: Compression, Gravitation, Darkness
-- Combos: None
-----------------------------------
require("scripts/globals/bluemagic")
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
    local dmg = 1 + (0.709 * caster:getSkillLevel(xi.skill.BLUE_MAGIC))
    local params = {}
    params.diff = caster:getStat(xi.mod.MND)-target:getStat(xi.mod.MND)
    params.attribute = xi.mod.MND
    params.skillType = xi.skill.BLUE_MAGIC
    params.bonus = 1.0
    local resist = xi.magic.applyResistance(caster, target, spell, params)
    dmg = dmg*resist
    dmg = xi.magic.addBonuses(caster, spell, target, dmg)
    dmg = xi.magic.adjustForTarget(target, dmg, spell:getElement())
    if (dmg > (caster:getSkillLevel(xi.skill.BLUE_MAGIC) + 20)) then
        dmg = (caster:getSkillLevel(xi.skill.BLUE_MAGIC) + 20)
    end

    if (dmg < 0) then
        dmg = 0
    end

    if (target:isUndead()) then
        spell:setMsg(xi.msg.basic.MAGIC_NO_EFFECT)
        return dmg
    end

    if (target:getHP() < dmg) then
        dmg = target:getHP()
    end

    params.attackType = xi.attackType.MAGICAL
    params.damageType = xi.damageType.DARK
    dmg = BlueFinalAdjustments(caster, target, spell, dmg, params)
    caster:addHP(dmg)

    return dmg
end

return spellObject
