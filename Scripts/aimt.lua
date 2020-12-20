--[[
  * Created by Oracle
  * license MIT
--]]

-- Constants --
TELEPORT_KEY = 46
RAYCAST_LENGTH = 100;
GIVE_ALL_PLAYERS_WEAPONS = true
DEG_2_RAD = math.pi / 180
ENABLE_AIM_TELEPORT = true
STARTUP_STRING = ('%s v%s initialized'):format(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'version', 0))

-- Variables --
local playerPed = PlayerPedId()
local playerId = PlayerId()

function GivePlayerAnEmptyPistol()
    if ENABLE_AIM_TELEPORT and GIVE_ALL_PLAYERS_WEAPONS then
        return GiveWeaponToPed(playerPed, 'WEAPON_PISTOL', 0, false, true);
    end
end

function TeleportAtAimPoint()

    if IsPlayerFreeAiming(playerId) then

        -- Small hack for a direction-based raycast --
        Citizen.CreateThread(function()

            local gameplayCamRotRad = GetGameplayCamRot(2) * DEG_2_RAD;
            local playerCoords = GetEntityCoords(playerPed)
            local queryId = StartShapeTestRay(playerCoords, playerCoords + vector3(-math.sin(gameplayCamRotRad.z) * math.abs(math.cos(gameplayCamRotRad.x)), math.cos(gameplayCamRotRad.z) * math.abs(math.cos(gameplayCamRotRad.x)), math.sin(gameplayCamRotRad.x)) * RAYCAST_LENGTH, -1, playerPed, 1)
            local _, wasHit, hitPos, _, _ = GetShapeTestResult(queryId);

            if wasHit == 1 then SetEntityCoords(playerPed, hitPos, true, true, true, false) end

        end)

    end

end

-- Reset globals once the player spawn (or in our case, respawn) --
AddEventHandler('playerSpawned', function()

    playerId = PlayerId()
    playerPed = PlayerPedId()

    return GivePlayerAnEmptyPistol()

end)

GivePlayerAnEmptyPistol()

Citizen.CreateThread(function()

    print(STARTUP_STRING)

    while ENABLE_AIM_TELEPORT do
        Citizen.Wait(0)
        if IsControlJustPressed(1, TELEPORT_KEY) then TeleportAtAimPoint() end
    end

end)


