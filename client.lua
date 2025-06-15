local Blips = {}

CreateThread(function()
    while true do
        local PlayerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(PlayerPed, false) then
            local Vehicle = GetVehiclePedIsIn(PlayerPed, false)
            local Speed = GetEntitySpeed(Vehicle) * 3.6
            local Coords = GetEntityCoords(Vehicle)

            for RadarId, Radar in pairs(Config.Radars) do
                local Distance = #(Coords - Radar.Coords)
                if Distance < Radar.Radius then
                    TriggerServerEvent("radar:server:checkSpeed", Speed, Coords, RadarId)
                end
            end
        end
        
        Wait(1000)
    end
end)

CreateThread(function()
    for RadarId, Radar in pairs(Config.Radars) do
        if Config.ShowBlips then
            local Blip = AddBlipForCoord(Radar.Coords)
            SetBlipSprite(Blip, 767)
            SetBlipScale(Blip, 0.8)
            SetBlipColour(Blip, 5)
            SetBlipAsShortRange(Blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Radar")
            EndTextCommandSetBlipName(Blip)
            Blips[RadarId] = Blip
        end
    end
end)

local ShowNotification = function(Text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(Text)
    DrawNotification(false, true)
end

RegisterNetEvent("radar:client:flashed")
AddEventHandler("radar:client:flashed", function(Name, Speed, MaxSpeed)
    local Text = ("~g~%s\n~s~Vous avez été flashé à une vitesse de %.0f km/h.\nLimitation : %.0f km/h"):format(Name, Speed, MaxSpeed)
    ShowNotification(Text)
end)

AddEventHandler('onResourceStop', function(ResourceName)
    if GetCurrentResourceName() == ResourceName then
        for _, Blip in pairs(Blips) do
            if DoesBlipExist(Blip) then
                RemoveBlip(Blip)
            end
        end
    end
end)