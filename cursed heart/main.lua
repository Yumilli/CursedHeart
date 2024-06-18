local mod = RegisterMod("Cursed Heart", 1)
local item = Isaac.GetItemIdByName("Cursed Heart")

if EID then EID:addCollectible(item, "#↑ +0.5 Damage#↑ x2.3 Fire rate multiplier#{{BlackHeart}} +2 Black Hearts#{{BrokenHeart}} You take double damage# Homing tears") end

local stats = {0.5, .3217}
local extracop = {2.5, 0}
function mod:stats(entity, cacheflag)
    local player = entity:ToPlayer()
    if player:HasCollectible(item) then
        local itemnum = player:GetCollectibleNum(item) - 1
        if cacheflag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + stats[1] + extracop[1] * itemnum
        elseif cacheflag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay * stats[2]
        elseif cacheflag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = Color(1.5, 0, 0) player.LaserColor = Color(1.5, 0, 0)
        elseif cacheflag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.stats)

local damaged = 0
function mod:takedmg(entity, amount, damageflag)
    local player = entity:ToPlayer()
    if player:HasCollectible(item) and damaged == 0 then damaged = 1
        player:TakeDamage(amount, damageflag, EntityRef(player), 0)
    else damaged = 0 end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.takedmg, EntityType.ENTITY_PLAYER)