# Aim Teleporter #

A short and sweet [FiveM][5m] script to teleport yourself where you are aiming.

## Setup ##

Just clone this repo to your ressource folder of your [FiveM][5m] server. You might also need to edit your `server.cfg` to
auto-load the resource.

### Permissions ###

Remember that Aim Teleporter **doesn't** do any permission management. By default, it allows **EVERY** player to teleport.

To prevent this, you can set the `ENABLE_AIM_TELEPORT` value in the `Scripts/aimt.lua` file to `false`.

Then, you can use the exported `TeleportAtAimPoint` function to your liking, granted that your server loads Aim Teleporter
first.

This will effectively makes Aim Teleporter act more like a library than a standalone ressource.

### Player Aiming Weapon ###

By default, Aim Teleporter will automatically give any player an empty pistol to enable then to aim freely.

To change this, you can set the `GIVE_ALL_PLAYERS_WEAPONS` value in the `Scripts/aimt.lua` file to `false`.

Disabling `ENABLE_AIM_TELEPORT` will also prevent players to get pistols too.

### Sounds ###

Aim Teleporter plays, by default, a sounds when a player teleports.

To mute Aim Teleporter, just set the `ENABLE_TELEPORT_SOUND` value to `false`.

## Controls ##

| Input                                         | Controls      |
|-----------------------------------------------|---------------|
| <kbd>E</kbd> <small>(while aiming)</small>    |  Teleport     |

**_BEWARE_ THAT THE SCRIPT <big style="color:red">DOESN'T PREVENT</big> PLAYERS FORM <big style="color:red" >TAKING
DAMAGES</big> AFTER TELEPORTING. <big style="color:red">USE IT AT YOUR OWN RISK</big>**

## Exports ##

Aim Teleporter also exports a `TeleportAtAimPoint` function that can be called to immediately teleport to the aiming position
from any other resources.

[5m]: (https://fivem.net) "FiveM"