-----------------------------------
-- Skullbreaker
-- Club weapon skill
-- Skill level: 150
-- Lowers enemy's INT. Chance of lowering INT varies with TP.
-- Will stack with Sneak Attack.
-- Aligned with the Snow Gorget & Aqua Gorget.
-- Aligned with the Snow Belt & Aqua Belt.
-- Element: None
-- Modifiers: STR:100%
-- 100%TP    200%TP    300%TP
-- 1.00      1.00      1.00
-----------------------------------
require("scripts/globals/status")
require("scripts/globals/settings")
require("scripts/globals/weaponskills")
-----------------------------------
local weaponskillObject = {}

weaponskillObject.onUseWeaponSkill = function(player, target, wsID, tp, primary, action, taChar)

    local params = {}
    params.numHits = 1
    params.ftp100 = 1 params.ftp200 = 1 params.ftp300 = 1
    params.str_wsc = 0.3 params.dex_wsc = 0.0 params.vit_wsc = 0.0 params.agi_wsc = 0.0 params.int_wsc = 0.0 params.mnd_wsc = 0.0 params.chr_wsc = 0.0
    params.crit100 = 0.0 params.crit200 = 0.0 params.crit300 = 0.0
    params.canCrit = false
    params.acc100 = 1.0 params.acc200= 1.0 params.acc300= 1.0
    params.atk100 = 1; params.atk200 = 1; params.atk300 = 1
    local damage, criticalHit, tpHits, extraHits = xi.weaponskills.doPhysicalWeaponskill(player, target, wsID, params, tp, action, primary, taChar)

    if (xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES == true) then
        params.str_wsc = 1.0
    end

    if (damage > 0 and target:hasStatusEffect(xi.effect.INT_DOWN) == false) then
        target:addStatusEffect(xi.effect.INT_DOWN, 10, 0, 140)
    end
    return tpHits, extraHits, criticalHit, damage

end

return weaponskillObject
