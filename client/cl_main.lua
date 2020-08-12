NearbyPlayers = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent("bayside-identity:SendProxMessage")
AddEventHandler("bayside-identity:SendProxMessage", function()
    GetClosestPlayer() -- get all players within proximity
    TriggerServerEvent("bayside-identity:SendProxMessage", NearbyPlayers)
    NearbyPlayers = {}
end)

Citizen.CreateThread(function()
    -- ID Card Shop
    while true do
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        if Vdist2(coords, Config.CourtLocation) < 30 then
            Citizen.Wait(1)
            if Vdist2(coords, Config.CourtLocation) < 5 then
                DrawText3D(Config.CourtLocation.x, Config.CourtLocation.y, Config.CourtLocation.z, "Press [~b~E~s~] to purchase ID for $200")
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('brp-identity:purchaseID', GetPlayerServerId(PlayerId()))
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

function GetClosestPlayer()
    print('Looking for closest players')
    local players = GetPlayers()
    print('Located', #players)
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        print('index', index, 'value', value)
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
            if(distance < 6) then
                print('Inserting a player into NearbyPlayers')
                table.insert(NearbyPlayers, GetPlayerServerId(value))                
            end
        end
    end
end

function GetPlayers()
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

Citizen.CreateThread(function()
    blip = AddBlipForCoord(Config.CourtLocation)
    SetBlipSprite(blip, Config.CourtBlipType)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, Config.BlipScale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipName)
    EndTextCommandSetBlipName(blip)
end)

function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x ,_y + 0.0125, 0.009 + factor, 0.03, 41, 11, 41, 120)
    end
end