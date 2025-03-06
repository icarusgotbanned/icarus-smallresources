local QBCore = exports['qb-core']:GetCoreObject()

-- SPAM PUNCHING OPTIMIZATION
CreateThread(function()
    while Config.spdisable do
        Wait(0)
        DisableControlAction(1, 140, true)
        if not IsPlayerTargettingAnything(PlayerId()) then
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

-- PREVENT LOSING HATS
if Config.hatgone then
    CreateThread(function()
        while true do
            Wait(1000)
            SetPedCanLosePropsOnDamage(PlayerPedId(), false, 0)
        end
    end)
end

local function getVehicleFromVehList(hash)
    for _, v in pairs(QBCore.Shared.Vehicles) do
        if hash == v.hash then
            return v.model
        end
    end
end

-- BLIND FIRE DISABLE
CreateThread(function()
    while Config.bfdisable do
        Wait(5)
        local ped = PlayerPedId()
        if IsPedInCover(ped, 1) and not IsPedAimingFromCover(ped, 1) then 
            DisableControlAction(2, 24, true)
            DisableControlAction(2, 142, true)
            DisableControlAction(2, 257, true)
        end
    end
end)

-- SAVE CAR FUNCTION
RegisterNetEvent('icarussr:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh and veh ~= 0 then
        local plate = QBCore.Functions.GetPlate(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local vehname = getVehicleFromVehList(props.model)
        if QBCore.Shared.Vehicles[vehname] then
            TriggerServerEvent('icarussr:server:SaveCar', props, QBCore.Shared.Vehicles[vehname], props.model, plate)
        else
            ShowNotification(Carry.shared, 'error')
        end
    else
        ShowNotification(Carry.nocar, 'error')
    end
end)

-- COMBAT ROLL DISABLE
CreateThread(function()
    while Config.crdisable do
        Wait(0)
        if IsPedArmed(PlayerPedId(), 4, 2) and IsControlPressed(0, 25) then
            DisableControlAction(0, 22, true)
        end
    end
end)

-- ACTION MODE DISABLE
CreateThread(function()
    while Config.amdisable do
        local ped = PlayerPedId()
        if IsPedUsingActionMode(ped) then
            SetPedUsingActionMode(ped, false, -1, 0)
        else
            Wait(500)
        end
        Wait(0)
    end
end)

-- FIRST-PERSON SHOOTING IN VEHICLES
if Config.FPShooting then
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local _, weapon = GetCurrentPedWeapon(ped)
            if IsPedInAnyVehicle(ped, false) and weapon ~= `WEAPON_UNARMED` then
                Wait(1)
                if IsControlJustPressed(0, 25) then
                    SetFollowVehicleCamViewMode(3)
                elseif IsControlJustReleased(0, 25) then
                    SetFollowVehicleCamViewMode(0)
                end
            else
                Wait(1000)
            end
        end
    end)
end

-- JUMP RAGDOLL MECHANIC
CreateThread(function()
    while Config.bhdisable do
        Wait(100)
        local ped = PlayerPedId()
        if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
            if math.random() < Config.rdchance then
                Wait(600)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
                SetPedToRagdoll(ped, 500, 1, 2)
            else
                Wait(2000)
            end
        end
    end
end)

-- CREATE BLIPS
CreateThread(function()
    for k, v in pairs(isr.Blips) do
        local blip = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
        SetBlipSprite(blip, v.Sprite)
        SetBlipScale(blip, v.Size)
        SetBlipColour(blip, v.Color)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(k)
        EndTextCommandSetBlipName(blip)
    end
end)

-- REMOVE BLIPS ON RESOURCE STOP
AddEventHandler('onResourceStop', function()
    for k, _ in pairs(isr.Blips) do
        RemoveBlip(isr.Blips[k])
    end
end)

-- PISTOL WHIP DISABLE
CreateThread(function()
    while Config.pistolwhip do
        Wait(0)
        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

-- SOUND REMOVAL
if Config.soundremove then
    CreateThread(function()
        SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, true)
        SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", true, true)
        SetAudioFlag("DisableFlightMusic", true)
        SetAudioFlag("PoliceScannerDisabled", true)
        SetDeepOceanScaler(0.0)
        SetRandomEventFlag(false)
    end)
end

-- NOTIFICATION FUNCTION
ShowNotification = function(message, type)
    lib.notify({
        title = Carry.title,
        description = message,
        icon = Carry.icon,
        type = type,
        position = Carry.position
    })
end
