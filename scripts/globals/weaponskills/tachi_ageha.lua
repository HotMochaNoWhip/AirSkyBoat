-----------------------------------
-- Tachi Ageha
-- Great Katana weapon skill
-- Skill Level: 300
-- Lowers target's defense. Chance of lowering target's defense varies with TP.
-- 30% Defense Down
-- Duration of effect is exactly 3 minutes.
-- Aligned with the Shadow Gorget, Soil Gorget.
-- Aligned with the Shadow Belt, Soil Belt.
-- Element: None
-- Skillchain Properties: Compression/Scission
-- Modifiers: CHR:60% STR:40%
-- 100%TP    200%TP    300%TP
-- 2.625     2.625      2.625
-----------------------------------
require("scripts/globals/status")
require("scripts/globals/settings")
require("scripts/globals/weaponskills")
-----------------------------------
local weaponskillObject = {}

weaponskillObject.onUseWeaponSkill = function(player, target, wsID, tp, primary, action, taChar)

    local params = {}
    params.numHits = 1
    params.ftp100 = 2.80 params.ftp200 = 2.80 params.ftp300 = 2.80
    params.str_wsc = 0.0 params.dex_wsc = 0.0 params.vit_wsc = 0.0 params.agi_wsc = 0.0 params.int_wsc = 0.0 params.mnd_wsc = 0.0 params.chr_wsc = 0.50
    params.crit100 = 0.0 params.crit200 = 0.0 params.crit300 = 0.0
    params.canCrit = false
    params.acc100 = 1.0 params.acc200= 1.0 params.acc300= 1.0
    params.atk100 = 1; params.atk200 = 1; params.atk300 = 1

    if (xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES == true) then
        params.ftp100 = 2.625 params.ftp200 = 2.625 params.ftp300 = 2.625
        params.str_wsc = 0.4 params.chr_wsc = 0.6
    end

    local damage, criticalHit, tpHits, extraHits = xi.weaponskills.doPhysicalWeaponskill(player, target, wsID, params, tp, action, primary, taChar)

    if (damage > 0 and target:hasStatusEffect(xi.effect.DEFENSE_DOWN) == false) then
        local duration = (tp/1000 * 60) * xi.magic.applyResistanceAddEffectWS(player, target, xi.magic.ele.WIND, 0)
        target:addStatusEffect(xi.effect.DEFENSE_DOWN, 25, 0, duration)
    end
    return tpHits, extraHits, criticalHit, damage

end

return weaponskillObject
