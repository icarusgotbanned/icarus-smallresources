local QBCore = exports['qb-core']:GetCoreObject()
local libState = started

-- ICARUS SMALL RESOURCES
-- Some snippets custom made, some snippets made from other creators 

-- SPAM PUNCHING
Citizen.CreateThread(function()
   while Config.spdisable do
   Citizen.Wait(0)
   DisableControlAction(1, 140, true)
   if not IsPlayerTargettingAnything(PlayerId()) then
   DisableControlAction(1, 141, true)
   DisableControlAction(1, 142, true)
   end
  end
end)

local ragdoll_chance = Config.rdchance

Citizen.CreateThread(function()
    while Config.hatgone do
        Citizen.Wait(1000)
        SetPedCanLosePropsOnDamage(PlayerPedId(), false, 0)
    end
end)


local function getVehicleFromVehList(hash)
	for _, v in pairs(QBCore.Shared.Vehicles) do
		if hash == v.hash then
			return v.model
		end
	end
end

-- BLIND FIRE
Citizen.CreateThread(function()
	while Config.bfdisable do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		if IsPedInCover(ped, 1) and not IsPedAimingFromCover(ped, 1) then 
			DisableControlAction(2, 24, true) 
			DisableControlAction(2, 142, true)
			DisableControlAction(2, 257, true)
		end		
	end
end)

RegisterNetEvent('icarussr:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = QBCore.Functions.GetPlate(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = getVehicleFromVehList(hash)
        if QBCore.Shared.Vehicles[vehname] ~= nil and next(QBCore.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('icarussr:server:SaveCar', props, QBCore.Shared.Vehicles[vehname], GetHashKey(veh), plate)
        else
            ShowNotification(Carry.shared, 'error')
        end
    else
            ShowNotification(Carry.nocar, 'error')
    end
end)

Citizen.CreateThread(function()
	while Config.crdisable do
		Citizen.Wait(0)
		if IsPedArmed(GetPlayerPed(-1), 4, 2) and IsControlPressed(0, 25) then
			DisableControlAction(0, 22, true)
		end
	end
end)

CreateThread(function()
	while Config.amdisable do
		local playerPed = PlayerPedId()
		if IsPedUsingActionMode(playerPed) then
			SetPedUsingActionMode(playerPed, false, -1, 0)
        else
            Wait(500)
        end
        Wait(0)
	end
end)

SetFlashLightKeepOnWhileMoving(true)

if Config.FPShooting then
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local _, weapon = GetCurrentPedWeapon(ped)
            local unarmed = "WEAPON_UNARMED"
            local inVeh = GetVehiclePedIsIn(PlayerPedId(), false)
            sleep = 1000
            if IsPedInAnyVehicle(PlayerPedId()) and weapon ~= unarmed then
                sleep = 1
                if IsControlJustPressed(0, 25) then
                    SetFollowVehicleCamViewMode(3)
                elseif IsControlJustReleased(0, 25) then
                    SetFollowVehicleCamViewMode(0)
                end
            end
            Wait(sleep)
        end
    end)
end


Citizen.CreateThread(function()
	while Config.bhdisable do
		Citizen.Wait(100) -- check every 100 ticks, performance matters
		local ped = PlayerPedId()
		if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
			local chance_result = math.random()
			if chance_result < ragdoll_chance then 
				Citizen.Wait(600)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
				SetPedToRagdoll(ped, 500, 1, 2)
			else
				Citizen.Wait(2000)
			end
		end
	end
end)

Citizen.CreateThread(function()
    for k,v in pairs(isr.Blips) do
        local blip = AddBlipForCoord(v.Coords.x,v.Coords.y,v.Coords.z)
        SetBlipSprite(blip, v.Sprite)
        SetBlipScale(blip, v.Size)
        SetBlipColour(blip, v.Color)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(k)
        EndTextCommandSetBlipName(blip)
    end
end)


AddEventHandler('onResourceStop', function()
    for k, v in pairs(isr.Blips) do
        local blip = AddBlipForCoord(v.Coords.x,v.Coords.y,v.Coords.z)
        RemoveBlip(blip)
    end
end)

Citizen.CreateThread(function()
    while Config.pistolwhip do
        Citizen.Wait(0)
        local ped = PlayerPedId()
                if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
        end
    end
end)

if Config.soundremove then
    Citizen.CreateThread(function()
        SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, true)
        SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", true, true)
        SetAudioFlag("DisableFlightMusic", true)
        SetAudioFlag("PoliceScannerDisabled", true)
        SetDeepOceanScaler(0.0)
        SetRandomEventFlag(false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE", false)
        SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE", false)
        SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM", false)
        SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM", false)
        SetStaticEmitterEnabled("se_dlc_aw_arena_construction_01", false)
        SetStaticEmitterEnabled("se_dlc_aw_arena_crowd_background_main", false)
        SetStaticEmitterEnabled("se_dlc_aw_arena_crowd_exterior_lobby", false)
        SetStaticEmitterEnabled("se_dlc_aw_arena_crowd_interior_lobby", false)
        StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
        StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
        StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
    end)
end


ShowNotification = function(message, type)
        lib.notify({
            title = Carry.title,
            description = message,
            icon = Carry.icon,
            type = type,
            position = Carry.position
        })
end