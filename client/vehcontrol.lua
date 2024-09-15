
RegisterCommand("trunk", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    local door = 5

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
            ShowInfo("[Vehicle] ~g~Trunk Closed.")
        else	
            SetVehicleDoorOpen(veh, door, false, false)
            ShowInfo("[Vehicle] ~g~Trunk Opened.")
        end
    else
        if distanceToVeh < 6 then
            if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                SetVehicleDoorShut(vehLast, door, false)
                ShowInfo("[Vehicle] ~g~Trunk Closed.")
            else
                SetVehicleDoorOpen(vehLast, door, false, false)
                ShowInfo("[Vehicle] ~g~Trunk Opened.")
            end
        else
            ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
        end
    end
end)

RegisterCommand("hood", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    local door = 4

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
            ShowInfo("[Vehicle] ~g~Hood Closed.")
        else	
            SetVehicleDoorOpen(veh, door, false, false)
            ShowInfo("[Vehicle] ~g~Hood Opened.")
        end
    else
        if distanceToVeh < 4 then
            if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                SetVehicleDoorShut(vehLast, door, false)
                ShowInfo("[Vehicle] ~g~Hood Closed.")
            else	
                SetVehicleDoorOpen(vehLast, door, false, false)
                ShowInfo("[Vehicle] ~g~Hood Opened.")
            end
        else
            ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
        end
    end
end)

RegisterCommand("door", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    
    if args[1] == "1" then -- Front Left Door
        door = 0
    elseif args[1] == "2" then -- Front Right Door
        door = 1
    elseif args[1] == "3" then -- Back Left Door
        door = 2
    elseif args[1] == "4" then -- Back Right Door
        door = 3
    else
        door = nil
        ShowInfo("Usage: ~n~~b~/door [door]")
        ShowInfo("~y~Possible doors:")
        ShowInfo("1: Front Left Door~n~2: Front Right Door")
        ShowInfo("3: Back Left Door~n~4: Back Right Door")
    end

    if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if GetVehicleDoorAngleRatio(veh, door) > 0 then
                SetVehicleDoorShut(veh, door, false)
                ShowInfo("[Vehicle] ~g~Door Closed.")
            else	
                SetVehicleDoorOpen(veh, door, false, false)
                ShowInfo("[Vehicle] ~g~Door Opened.")
            end
        else
            if distanceToVeh < 4 then
                if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                    SetVehicleDoorShut(vehLast, door, false)
                    ShowInfo("[Vehicle] ~g~Door Closed.")
                else	
                    SetVehicleDoorOpen(vehLast, door, false, false)
                    ShowInfo("[Vehicle] ~g~Door Opened.")
                end
            else
                ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
            end
        end
    end
end)

if usingKeyPress then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsUsing(ped)
            local vehLast = GetPlayersLastVehicle()
            local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
            local door = 5
            if IsControlPressed(1, 224) and IsControlJustPressed(1, togKey) then
                if not IsPedInAnyVehicle(ped, false) then
                    if distanceToVeh < 4 then
                        if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                            SetVehicleDoorShut(vehLast, door, false)
                            ShowInfo("[Vehicle] ~g~Trunk Closed.")
                        else	
                            SetVehicleDoorOpen(vehLast, door, false, false)
                            ShowInfo("[Vehicle] ~g~Trunk Opened.")
                        end
                    else
                        ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
                    end
                end
            end
        end
    end)
end



function ShowAboveRadarMessage(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end

RegisterNetEvent('showNotify')
AddEventHandler('showNotify', function(notify)
    ShowAboveRadarMessage(notify)
end)
local window0 = true
local window1 = true
local window2 = true
local window3 = true

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/window', '1, 2, 3, 4, 12, 34, All')
end)



RegisterNetEvent("CarWindowS")
AddEventHandler("CarWindowS", function(sender, window)
    local playerPed = GetPlayerPed(GetPlayerFromServerId(sender))
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
        if ( GetPedInVehicleSeat(playerCar, -1) == playerPed ) then
            if ( window == "1" and window0 == true)  then
                RollDownWindow(playerCar, 0)
                window0 = false
            elseif ( window == "1" and window0 == false) then
                RollUpWindow(playerCar, 0)
                window0 = true
            elseif ( window == "2" and window1 == true) then
                RollDownWindow(playerCar, 1)
                window1 = false
            elseif ( window == "2" and window1 == false) then
                RollUpWindow(playerCar, 1)
                window1 = true
            elseif ( window == "3" and window2 == true) then
                RollDownWindow(playerCar, 2)
                window2 = false
            elseif ( window == "3" and window2 == false) then
                RollUpWindow(playerCar, 2)
                window2 = true
            elseif ( window == "4" and window3 == true) then
                RollDownWindow(playerCar, 3)
                window3 = false
            elseif ( window == "4" and window3 == false) then
                RollUpWindow(playerCar, 3)
                window3 = true
            elseif ( window == "12" and (window0 and window1)== true) then
                RollDownWindow(playerCar, 0)
                RollDownWindow(playerCar, 1)
                window0 = false
                window1 = false
            elseif ( window == "12" and (window0 and window1) == false) then
                RollUpWindow(playerCar, 0)
                RollUpWindow(playerCar, 1)
                window0 = true
                window1 = true
            elseif ( window == "34" and (window2 and window3) == true) then
                RollDownWindow(playerCar, 2)
                RollDownWindow(playerCar, 3)
                window2 = false
                window3 = false
            elseif ( window == "34" and (window2 and window3) == false) then
                RollUpWindow(playerCar, 2)
                RollUpWindow(playerCar, 3)
                window2 = true
                window3 = true
            elseif ( window == "all" and ( window0 and window1 and window2 and window3 ) == true ) then
                RollDownWindow(playerCar, 0)
                RollDownWindow(playerCar, 1)
                RollDownWindow(playerCar, 2)
                RollDownWindow(playerCar, 3)
                window0 = false
                window1 = false
                window2 = false
                window3 = false
            elseif ( window == "all" and ( window0 and window1 and window2 and window3 ) == false ) then
                RollUpWindow(playerCar, 0)
                RollUpWindow(playerCar, 1)
                RollUpWindow(playerCar, 2)
                RollUpWindow(playerCar, 3)
                window0 = true
                window1 = true
                window2 = true
                window3 = true
            end
        elseif ( GetPedInVehicleSeat(playerCar, 0) == playerPed ) then
            if ( window == "fr" ) and  ( window1 == true ) then
                RollDownWindow(playerCar, 1)
                window1 = false
            elseif ( window == "fr" ) and ( window1 == false ) then
                RollUpWindow(playerCar, 1)
                window1 = true
            elseif window == "fl" or "br" or "bl" then
                TriggerEvent('showNotify', "~r~You can't roll this window down", GetPlayerName(source))
            end
        elseif ( GetPedInVehicleSeat(playerCar, 1) == playerPed ) then
            if ( window == "bl" ) and ( window2 == true ) then
                RollDownWindow(playerCar, 2)
                window2 = false
            elseif ( window == "bl" ) and ( window2 == false ) then
                RollUpWindow(playerCar, 2)
                window2 = true
            elseif window == "fl" or "br" or "fr" then
                TriggerEvent('showNotify', "~r~You can't roll this window down", GetPlayerName(source))
            end
        elseif ( GetPedInVehicleSeat(playerCar, 2) == playerPed ) then
            if ( window == "br" ) and ( window3 == true ) then
                RollDownWindow(playerCar, 3)
                window3 = false
            elseif ( window == "br" ) and ( window3 == false )  then
                RollUpWindow(playerCar, 3)
                window3 = true
            elseif window == "fl" or "bl" or "fr" then
                TriggerEvent('showNotify', "~r~You can't roll this window down", GetPlayerName(source))
            end
        end
    end
end)

-- Seat Detector And Window Advisor
RegisterNetEvent("SeatDAWA")
AddEventHandler("SeatDAWA", function(sender)
    TriggerEvent('showNotify', "~r~Please select a window", GetPlayerName(source))
end)
