local QBCore = exports['qb-core']:GetCoreObject()
local isEscorting = false
local PlayerStatus = {}

-- ADMIN OWN CAR
QBCore.Commands.Add('savecar', {}, {}, false, function(source)
    TriggerClientEvent('icarussr:client:SaveCar', source)
end, 'admin')

RegisterNetEvent('icarussr:server:SaveCar', function(mods, vehicle, _, plate)
    local src = source
    if not (QBCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command')) then
        return BanPlayer(src)
    end
    
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.query.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    
    if not result[1] then
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.license,
            Player.PlayerData.citizenid,
            vehicle.model,
            vehicle.hash,
            json.encode(mods),
            plate,
            0
        })
    end
    ShowNotification(Carry.carown, 'success')
end)

RegisterCommand("window", function(source, args)
    if args[1] then
        TriggerClientEvent("CarWindowS", -1, source, args[1])
    else
        TriggerClientEvent("SeatDAWA", source)
    end
end, false)

QBCore.Commands.Add('carry', "Carry", {}, false, function(source)
    TriggerClientEvent('icarus:client:CarryPlayer', source)
end)

RegisterNetEvent('icarus:server:CarryPlayer', function(playerId)
    local src = source
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(playerId)
    
    if #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) > 2.5 then
        return DropPlayer(src, 'Attempted exploit abuse')
    end
    
    local Player = QBCore.Functions.GetPlayer(src)
    local EscortPlayer = QBCore.Functions.GetPlayer(playerId)
    if not Player or not EscortPlayer then return end
    
    local metadata = EscortPlayer.PlayerData.metadata
    if metadata['ishandcuffed'] or metadata['isdead'] or metadata['inlaststand'] then
        TriggerClientEvent('icarus:client:Carried', EscortPlayer.PlayerData.source, Player.PlayerData.source)
        TriggerClientEvent('icarus:client:Carrier', Player.PlayerData.source, EscortPlayer.PlayerData.source)
    else
        ShowNotification(Carry.notcuffed, 'error')
    end
end)

function ShowNotification(message, type)
    lib.notify({
        title = Carry.title,
        description = message,
        icon = Carry.icon,
        type = type,
        position = Carry.position
    })
end
