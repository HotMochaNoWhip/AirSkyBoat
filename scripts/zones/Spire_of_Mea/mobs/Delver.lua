-----------------------------------
-- Area: Spire of Mea
--  Mob: Delver
-----------------------------------
mixins = { require("scripts/mixins/families/empty_terroanima") }
-----------------------------------
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMod(xi.mod.DOUBLE_ATTACK, 20)
    mob:addMod(xi.mod.DEFP,35)
    mob:setMod(xi.mod.STORETP, 100)
end

entity.onMobWeaponSkillPrepare = function(mob, target)
    local roll = math.random()
    if mob:getHPP() <= 35 then
        if roll <= 0.7 then
            return 1234 -- Carousel
        else
            return 1274 -- Impalement
        end
    end
end

entity.onMobFight = function(mob, target)
    if mob:getHPP() <= 35 then
        mob:setMod(xi.mod.STORETP, 250)
    end
end

return entity
