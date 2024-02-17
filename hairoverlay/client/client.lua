local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('hairoverlay:server:initializeHairOverlay')
end)

RegisterNetEvent('hairoverlay:client:initializeHairOverlay', function()
    print(PlayerPedId()) -- Different player ped id from the one inside callback (likely from SetPlayerModel being called)

    QBCore.Functions.TriggerCallback('hairoverlay:server:cb_getCurrentHairOverlay', function(hairoverlay)
        if hairoverlay then
            print(PlayerPedId()) -- The correct player ped id
            AddPedDecorationFromHashes(PlayerPedId(), hairoverlay.collection, hairoverlay.overlay)
        end
    end)
end)

RegisterCommand('hairoverlay', function(_, args, _)
    local index = tonumber(args[1]) or 1
    local hairoverlay = HairOverlaysMale[index].collection

    QBCore.Functions.TriggerCallback('hairoverlay:server:cb_setHairOverlay', function(success)
        if success then
            AddPedDecorationFromHashes(PlayerPedId(), hairoverlay.collection, hairoverlay.overlay)
            TriggerEvent('QBCore:Notify', "Hair overlay applied", "success")
        end
    end, hairoverlay)
end, false)
