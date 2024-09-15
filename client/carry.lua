QBCore = exports['qb-core']:GetCoreObject()
isHandcuffed = false
cuffType = 1
isEscorted = false
PlayerJob = {}
local isEscorting = false

-- Main Event
RegisterNetEvent('icarus:client:CarryPlayer', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not IsPedInAnyVehicle(GetPlayerPed(player)) then
            if not isHandcuffed and not isEscorted then
                TriggerServerEvent('icarus:server:CarryPlayer', playerId)
            end
        end
    else
            ShowNotification(Carry.nonear, 'error')
    end
end)

--Carried
RegisterNetEvent('icarus:client:Carried', function(playerId)
    local ped = PlayerPedId()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata['isdead'] or PlayerData.metadata['inlaststand'] or isHandcuffed then
            if not isEscorted then
                isEscorted = true
                local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
                RequestAnimDict('nm')

                while not HasAnimDictLoaded('nm') do
                    Wait(10)
                end
                AttachEntityToEntity(ped, dragger, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
                TaskPlayAnim(ped, 'nm', 'firemans_carry', 8.0, -8.0, 100000, 33, 0, false, false, false)
            else
                isEscorted = false
                DetachEntity(ped, true, false)
                ClearPedTasksImmediately(ped)
            end
            TriggerEvent('hospital:client:isEscorted', isEscorted)
        end
    end)
end)

RegisterNetEvent('icarus:client:Carrier', function()
    QBCore.Functions.GetPlayerData(function(_)
        if not isEscorting then
            local dragger = PlayerPedId()
            RequestAnimDict('missfinale_c2mcs_1')

            while not HasAnimDictLoaded('missfinale_c2mcs_1') do
                Wait(10)
            end
            TaskPlayAnim(dragger, 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 8.0, -8.0, 100000, 49, 0, false, false, false)
            isEscorting = true
        else
            local dragger = PlayerPedId()
            ClearPedSecondaryTask(dragger)
            ClearPedTasksImmediately(dragger)
            isEscorting = false
        end
        TriggerEvent('hospital:client:SetEscortingState', isEscorting)
        TriggerEvent('hospital:client:SetKidnapping', isEscorting)
    end)
end)

RegisterNetEvent('hospital:client:SetEscortingState', function(bool)
    isEscorting = bool
end)

RegisterNetEvent('hospital:client:isEscorted', function(bool)
    isEscorted = bool
end)

