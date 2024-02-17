local QBCore = exports['qb-core']:GetCoreObject()
local currentHairOverlay = {}

RegisterNetEvent('hairoverlay:server:initializeHairOverlay', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.query('SELECT hairoverlay FROM players WHERE citizenid = @citizenid', {
        ['@citizenid'] = Player.PlayerData.citizenid
    }, function(result)
        if result[1].hairoverlay then
            currentHairOverlay = json.decode(result[1].hairoverlay)
            TriggerClientEvent('hairoverlay:client:initializeHairOverlay', src)
        end
    end)
end)

QBCore.Functions.CreateCallback('hairoverlay:server:cb_getCurrentHairOverlay', function(source, cb)
    cb(currentHairOverlay)
end)

QBCore.Functions.CreateCallback('hairoverlay:server:cb_setHairOverlay', function(source, cb, newHairOverlay)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    MySQL.query('UPDATE players SET hairoverlay = @hairoverlay WHERE citizenid = @citizenid', {
        ['@hairoverlay'] = json.encode(newHairOverlay),
        ['@citizenid'] = Player.PlayerData.citizenid
    })

    cb(true)
end)
