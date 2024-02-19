local QBCore = exports['qb-core']:GetCoreObject()
local currentHairOverlay = { collection = '', hairoverlay = '' }

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('hairoverlay:server:initializeHairOverlay')
end)

RegisterNetEvent('hairoverlay:client:initializeHairOverlay', function()
    print(PlayerPedId()) -- Different player ped id from the one inside callback (likely from SetPlayerModel being called)

    QBCore.Functions.TriggerCallback('hairoverlay:server:cb_getCurrentHairOverlay', function(hairoverlay)
        if hairoverlay then
            print(PlayerPedId()) -- The correct player ped id
            AddPedDecorationFromHashes(PlayerPedId(), hairoverlay.collection, hairoverlay.overlay)
            currentHairOverlay = hairoverlay
        end
    end)
end)

RegisterCommand('hairoverlay', function(_, args, _)
    local playerPed = PlayerPedId()
    local index = tonumber(args[1]) or 1
    local hairoverlay = HairOverlaysMale[index]
    local decorations = GetPedDecorations(playerPed)

    ClearPedDecorations(playerPed)

    for _, value in pairs(decorations) do
        if currentHairOverlay.overlay ~= value[2] then
            AddPedDecorationFromHashes(playerPed, value[1], value[2])
        end
    end

    QBCore.Functions.TriggerCallback('hairoverlay:server:cb_setHairOverlay', function(success)
        if success then
            AddPedDecorationFromHashes(playerPed, hairoverlay.collection, hairoverlay.overlay)
            currentHairOverlay = hairoverlay
            TriggerEvent('QBCore:Notify', "Hair overlay applied", "success")
        end
    end, hairoverlay)
end, false)
