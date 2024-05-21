local mod = RegisterMod("Cursed Heart", 1)
local item = Isaac.GetItemIdByName("Cursed Heart")

if EID then EID:addCollectible(item, "#↑ +1 Damage#↑ x2 Fire rate multiplier#{{BlackHeart}} +1 Black Heart#{{BrokenHeart}} You take double damage# Homing tears") end

local val = {0, 0}
local stats = {1, .4}
local extracop = {2.5, 0}
function mod:stats(entity, cf)
    local player = entity:ToPlayer()
    local itemnum = player:GetCollectibleNum(item)
    if player:HasCollectible(item) and (cf == CacheFlag.CACHE_DAMAGE or cf == CacheFlag.CACHE_FIREDELAY or cf == CacheFlag.CACHE_TEARCOLOR or cf == CacheFlag.CACHE_TEARFLAG) then
        player.TearColor = Color(1.5, 0, 0) player.LaserColor = Color(1.5, 0, 0)
        player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
        if val[1] ~= player.Damage - stats[1] + extracop[1] * (itemnum - 1) then
            player.Damage = player.Damage + stats[1] + extracop[1] * (itemnum - 1)
            val[1] = player.Damage - stats[1] + extracop[1] * (itemnum - 1)
        end
        if val[2] ~= player.MaxFireDelay / stats[2] then
            player.MaxFireDelay = player.MaxFireDelay * stats[2]
            val[2] = player.MaxFireDelay / stats[2]
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