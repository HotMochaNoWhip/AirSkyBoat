-----------------------------------
-- Spell: Curaga III
-- Restores HP of all party members within area of effect.
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
    local minCure = 270

    local divisor = 0.6666
    local constant = 165
    local power = xi.magic.getCurePowerOld(caster)
    if (power > 460) then
        divisor = 6.5
        constant = 354.6666
    elseif (power > 220) then
        divisor = 2
        constant = 275
    end

    local final = xi.magic.getCureFinal(caster, spell, xi.magic.getBaseCureOld(power, divisor, constant), minCure, false)

    final = final + (final * (target:getMod(xi.mod.CURE_POTENCY_RCVD)/100))

    --Applying server mods
    final = final * xi.settings.main.CURE_POWER

    local diff = (target:getMaxHP() - target:getHP())
    if (final > diff) then
        final = diff
    end
    target:addHP(final)

    target:wakeUp()
    caster:updateEnmityFromCure(target, final)

    spell:setMsg(xi.msg.basic.AOE_HP_RECOVERY)

    local mpBonusPercent = (final*caster:getMod(xi.mod.CURE2MP_PERCENT))/100
    if (mpBonusPercent > 0) then
        caster:addMP(mpBonusPercent)
    end

    return final
end

return spellObject
