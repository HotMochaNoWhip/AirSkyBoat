-----------------------------------
-- Tachi Kagero
-- Great Katana weapon skill
-- Skill Level: 100
-- Deals fire elemental damage to enemy. Damage varies with TP.
-- Will stack with Sneak Attack.
-- Aligned with the Flame Gorget.
-- Aligned with the Flame Belt.
-- Element: Fire
-- Modifiers: STR:75%
-- 100%TP    200%TP    300%TP
-- .5        .75       1.00
-----------------------------------
require("scripts/globals/magic")
require("scripts/globals/status")
require("scripts/globals/settings")
require("scripts/globals/weaponskills")
-----------------------------------
local weaponskillObject = {}

weaponskillObject.onUseWeaponSkill = function(player, target, wsID, tp, primary, action, taChar)

    local params = {}
    params.numHits = 1
    params.ftp100 = 1 params.ftp200 = 1 params.ftp300 = 1
    params.str_wsc = 0.5 params.dex_wsc = 0.0 params.vit_wsc = 0.0 params.agi_wsc = 0.0 params.int_wsc = 0.0 params.mnd_wsc = 0.0 params.chr_wsc = 0.0
    params.crit100 = 0.0 params.crit200 = 0.0 params.crit300 = 0.0
    params.canCrit = false
    params.acc100 = 1.0 params.acc200= 1.0 params.acc300= 1.0
    params.atk100 = 1; params.atk200 = 1; params.atk300 = 1
    params.hybridWS = true
    params.element = xi.magic.ele.FIRE
    params.skillType = xi.skill.GREAT_KATANA
    params.includemab = true

    if (xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES == true) then
        params.ftp100 = 0.5 params.ftp200 = 0.75 params.ftp300 = 1
        params.str_wsc = 0.75
    end

    local damage, criticalHit, tpHits, extraHits = xi.weaponskills.doPhysicalWeaponskill(player, target, wsID, params, tp, action, primary, taChar)
    return tpHits, extraHits, criticalHit, damage

end

return weaponskillObject
