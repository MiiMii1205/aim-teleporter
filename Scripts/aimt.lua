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

-- Variables --
local playerPed = PlayerPedId()
local playerId = PlayerId()
local isCalculating = false

if ENABLE_AIM_TELEPORT and GIVE_ALL_PLAYERS_WEAPONS then
    GiveWeaponToPed(playerPed, 'WEAPON_PISTOL', 0, false, true);
end

function TeleportAtAimPoint()

    if (not isCalculating) and IsPlayerFreeAiming(playerId) then

        local pedCoords = GetEntityCoords(playerPed);
        local gameplayCamRotRad = GetGameplayCamRot(2) * DEG_2_RAD;

        local p1 = pedCoords
        -- Small hack for a direction-based raycast --
        local p2 = p1 + vector3(-math.sin(gameplayCamRotRad.z) * math.abs(math.cos(gameplayCamRotRad.x)), math.cos(gameplayCamRotRad.z) * math.abs(math.cos(gameplayCamRotRad.x)), math.sin(gameplayCamRotRad.x)) * RAYCAST_LENGTH;

        Citizen.CreateThread(function()

            local queryId = StartShapeTestRay(
                    p1.x, p1.y, p1.z,
                    p2.x, p2.y, p2.z,
                    -1,
                    playerPed,
                    1
            )

            isCalculating = true

            local _, wasHit, hitPos, _, _ = GetShapeTestResult(queryId);

            if wasHit == 1 then
                SetEntityCoords(playerPed, hitPos.x, hitPos.y, hitPos.z, true, true, true, false);
            end

            isCalculating = false

        end)

    end

end

-- Reset globals once the player spawn (or in our case, respawn) --
AddEventHandler('playerSpawned', function()

    playerId = PlayerId()
    playerPed = PlayerPedId()

    if ENABLE_AIM_TELEPORT and GIVE_ALL_PLAYERS_WEAPONS then
        GiveWeaponToPed(playerPed, 'WEAPON_PISTOL', 0, false, true);
    end

end)

Citizen.CreateThread(function()

    print(('%s v%s initialized'):format(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'version', 0)))

    while true do

        Citizen.Wait(0)

        if ENABLE_AIM_TELEPORT and IsControlJustPressed(1, TELEPORT_KEY) then

            TeleportAtAimPoint()

        end

    end

end)


