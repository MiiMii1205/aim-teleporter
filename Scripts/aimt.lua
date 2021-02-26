--[[
  * Created by MiiMii1205
  * license MIT
--]]

-- Constants --
TELEPORT_KEY = 46               -- Control code for the teleportation key
RAYCAST_LENGTH = 100;           -- Maximal teleportation length in meters
GIVE_ALL_PLAYERS_WEAPONS = true -- Indicates if every player should get an empty gun to aim with
DEG_2_RAD = math.pi / 180       -- Caching is fun! We're storing a factor that can be used to instantly transform degrees to radians
ENABLE_AIM_TELEPORT = true      -- Enables the main aim-teleportation loop
ENABLE_TELEPORT_SOUND = true    -- Enables sound support
INSTRUCTOR_ENABLED = true       -- Enables Instructor support

RESOURCE_NAME = GetCurrentResourceName()
STARTUP_STRING = ('%s v%s initialized'):format(RESOURCE_NAME, GetResourceMetadata(RESOURCE_NAME, 'version', 0))
STARTUP_HTML_STRING = (':point_left: %s <small>v%s</small> initialized'):format(RESOURCE_NAME, GetResourceMetadata(RESOURCE_NAME, 'version', 0))

-- Variables --
local playerPed = PlayerPedId()
local playerId = PlayerId()
local isAimingInstructionActive = false;

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

            if wasHit == 1 then
                SetEntityCoords(playerPed, hitPos, true, true, true, false)

                if ENABLE_TELEPORT_SOUND then
                    PlaySoundFromCoord(-1, "Change_Station_Loud", hitPos, "Radio_Soundset", 1, RAYCAST_LENGTH / 2, 1)
                end

                TriggerEvent('msgprinter:addMessage', (":sparkle: Teleported to <samp>(%.2f, %.2f, %.2f)</samp>"):format(table.unpack(hitPos)), RESOURCE_NAME);

            end

        end)

    end

end

---UpdatePedAimingInstruction Toggles the "Aim to teleport" instruction for the instructor
---@param isEnabled boolean should the instruction be shown?
function UpdateAimingInstruction(isEnable)
    if isAimingInstructionActive ~= isEnable then
        isAimingInstructionActive = isEnable;
        if isAimingInstructionActive then
            TriggerEvent('instructor:show-instruction', TELEPORT_KEY, RESOURCE_NAME)
        else
            TriggerEvent('instructor:hide-instruction', TELEPORT_KEY, RESOURCE_NAME)
        end
    end
end

---ManageInstructor Manages the Instructor
function ManageInstructor()
    UpdateAimingInstruction(IsPlayerFreeAiming(playerId) ~= false);
end

-- Reset globals once the player spawn (or in our case, respawn) --
AddEventHandler('playerSpawned', function()
    playerId = PlayerId()
    playerPed = PlayerPedId()
    return GivePlayerAnEmptyPistol()
end)

AddEventHandler('RCC:newPed', function()
    playerPed = PlayerPedId()
    playerId = PlayerId()
    return GivePlayerAnEmptyPistol()
end)

GivePlayerAnEmptyPistol()

-- Main Thread --
Citizen.CreateThread(function()

    print(STARTUP_STRING)
    TriggerEvent('msgprinter:addMessage', STARTUP_HTML_STRING, RESOURCE_NAME);

    if INSTRUCTOR_ENABLED then
        TriggerEvent('instructor:add-instruction', TELEPORT_KEY, "Teleport", RESOURCE_NAME, isAimingInstructionActive);

        while ENABLE_AIM_TELEPORT do
            Citizen.Wait(0)
            if IsControlJustPressed(1, TELEPORT_KEY) then TeleportAtAimPoint() end
            ManageInstructor();
        end

        TriggerEvent('instructor:flush', RESOURCE_NAME);
    else
        while ENABLE_AIM_TELEPORT do
            Citizen.Wait(0)
            if IsControlJustPressed(1, TELEPORT_KEY) then TeleportAtAimPoint() end
        end
    end


end)


