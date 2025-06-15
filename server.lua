local ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent("radar:server:checkSpeed")
AddEventHandler("radar:server:checkSpeed", function(Speed, Coords, RadarId)
    local PlayerSource = source

    local xPlayer = ESX.GetPlayerFromId(PlayerSource)
    if not xPlayer then return end

    local Radar = Config.Radars[RadarId]
    if not Radar then return end

    if Config.Bypass[xPlayer.job.name] then
        return
    end

    local PlayerPed = GetPlayerPed(PlayerSource)
    local PlayerCoords = GetEntityCoords(PlayerPed)

    local ClientDistance = #(Coords - Radar.Coords)
    local ServerDistance = #(PlayerCoords - Radar.Coords)

    if ClientDistance > Radar.Radius or ServerDistance > Radar.Radius then
        DropPlayer(PlayerSource, "Assurez vous de ne pas utiliser de cheat.")
        return
    end

    if Speed > Radar.MaxSpeed then
        
        if xPlayer.getAccount("bank").money >= Radar.Fine then
            xPlayer.removeAccountMoney("bank", Radar.Fine)
        end

        TriggerClientEvent("radar:client:flashed", PlayerSource, Radar.Name, Speed, Radar.MaxSpeed)
    end
end)