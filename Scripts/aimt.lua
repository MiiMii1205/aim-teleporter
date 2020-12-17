-- Constants --
TELEPORT_KEY = 44
RAYCAST_LENGTH = 100;
GIVE_ALL_PLAYERS_WEAPONS = true
DEG_2_RAD = math.pi / 180

-- Variables --
local playerPed = PlayerPedId()
local playerId = PlayerId()
local isCalculating = false

if GIVE_ALL_PLAYERS_WEAPONS then
    GiveWeaponToPed(playerPed, 'WEAPON_PISTOL', 0, false, true);
end

function TeleportAtAimPoint()

    local pedCoords = GetEntityCoords(playerPed);
    local rot = GetGameplayCamRot(2) * DEG_2_RAD;

    local p1 = pedCoords
    local p2 = p1 + vector3(-math.sin(rot.z) * math.abs(math.cos(rot.x)), math.cos(rot.z) * math.abs(math.cos(rot.x)), math.sin(rot.x)) * RAYCAST_LENGTH;

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

-- On rechange le playerPed quand le joueur spawn (ou respawn dans notre cas) --
AddEventHandler('playerSpawned', function()

    playerId = PlayerId()
    playerPed = PlayerPedId()

    if GIVE_ALL_PLAYERS_WEAPONS then
        GiveWeaponToPed(playerPed, 'WEAPON_PISTOL', 0, false, true);
    end

end)

Citizen.CreateThread(function()

    print(('%s v%s initialized'):format(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'version', 0)))

    while true do

        Citizen.Wait(0)

        if ENABLE_AIM_TELEPORT and (not isCalculating) and IsPlayerFreeAiming(playerId) and IsControlJustPressed(1, TELEPORT_KEY) then

            TeleportAtAimPoint()

        end

    end

end)

