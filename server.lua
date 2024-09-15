local QBCore = exports['qb-core']:GetCoreObject()
local isEscorting = false
local PlayerStatus = {}

-- ADMIN OWN CAR
QBCore.Commands.Add('savecar',{}, {}, false, function(source, _)
    TriggerClientEvent('icarussr:client:SaveCar', source)
end, 'admin')

RegisterNetEvent('icarussr:server:SaveCar', function(mods, vehicle, _, plate)
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
        local Player = QBCore.Functions.GetPlayer(src)
        local result = MySQL.query.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
        if result[1] == nil then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                Player.PlayerData.license,
                Player.PlayerData.citizenid,
                vehicle.model,
                vehicle.hash,
                json.encode(mods),
                plate,
                0
            })
            ShowNotification(Carry.carown, 'success')
        else
            ShowNotification(Carry.carown, 'success')
        end
    else
        BanPlayer(src)
    end
end)

RegisterCommand("window", function(source, args)

    local window = args[1]
    if not args[1] then
        TriggerClientEvent("SeatDAWA", source)
    else
        TriggerClientEvent("CarWindowS", -1, source, window)
    end
end, false)

QBCore.Commands.Add('carry', "Carry", {}, false, function(source)
    local src = source
    TriggerClientEvent('icarus:client:CarryPlayer', src)
end)

RegisterNetEvent('icarus:server:CarryPlayer', function(playerId)
    local src = source
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    if #(playerCoords - targetCoords) > 2.5 then return DropPlayer(src, 'Attempted exploit abuse') end

    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if not Player or not EscortPlayer then return end

    if EscortPlayer.PlayerData.metadata['ishandcuffed'] or EscortPlayer.PlayerData.metadata['isdead'] or EscortPlayer.PlayerData.metadata['inlaststand'] then
        TriggerClientEvent('icarus:client:Carried', EscortPlayer.PlayerData.source, Player.PlayerData.source)
        TriggerClientEvent('icarus:client:Carrier', Player.PlayerData.source, EscortPlayer.PlayerData.source)
    else
            ShowNotification(Carry.notcuffed, 'error')
    end
end)

ShowNotification = function(message, type)
        lib.notify({
            title = Carry.title,
            description = message,
            icon = Carry.icon,
            type = type,
            position = Carry.position
        })
end