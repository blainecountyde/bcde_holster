local config = require 'config'
if not config.CanStart() then
    return
end

local unarmed = `WEAPON_UNARMED`
local isLoggedIn = LocalPlayer and LocalPlayer.state and LocalPlayer.state.isLoggedIn
local modifiedHolsters = {}
local handOnHolster = false

if exports['qb-core'] ~= nil then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        isLoggedIn = true
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        isLoggedIn = false
        modifiedHolsters = {}
    end)
end

function IsWearingHolster(weapon)
    for k in pairs(config.holster) do
        local holsterConf = config.holster[k]
        if holsterConf.weapons[weapon] then
            local clothes = config.GetCurrentClothing(holsterConf.component + 1)
            local map = holsterConf.mappings[tostring(clothes.drawable)]
            if map or modifiedHolsters[k] then
                return true
            end
        end
    end
    return false
end

exports('IsWearingHolster', IsWearingHolster)

function checkHolster(weapon, key, holsterConf)
    local isUnarmed = weapon == unarmed
    local isModified = modifiedHolsters[key] ~= nil

    if not isModified and holsterConf.weapons[weapon] then
        local clothes = config.GetCurrentClothing(holsterConf.component + 1)
        local map = holsterConf.mappings[tostring(clothes.drawable)]
        if map then
            SetPedComponentVariation(PlayerPedId(), holsterConf.component, map, 0, 0)
            modifiedHolsters[key] = {
                id = clothes.drawable,
                tex = clothes.texture  
            }
        end
    elseif isUnarmed and isModified then
        SetPedComponentVariation(PlayerPedId(), holsterConf.component, modifiedHolsters[key].id, modifiedHolsters[key].tex, 0)
        modifiedHolsters[key] = nil
    end
end

function checkHolsters(weapon)
    for k in pairs(config.holster) do
        local holsterConf = config.holster[k]
        checkHolster(weapon, k, holsterConf)
    end
end

CreateThread(function()
    while true do
        if isLoggedIn then
            local weapon = GetSelectedPedWeapon(PlayerPedId())
            checkHolsters(weapon)
        end
        Citizen.Wait(100)
    end
end)