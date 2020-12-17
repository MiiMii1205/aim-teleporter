# Aim Teleporter #

A short and sweet [FiveM](https://fivem.net) script to teleport yourself where you are aiming.

## Setup ##

Just clone this repo to your ressource folder of your [FiveM](https://fivem.net) server. You might also need to edit your server.cfg to auto load the resource.

Remember that this resource doesn't do any permission management. By default, it allows **EVERY** player to teleport.

To change this, you can set the `ENABLE_AIM_TELEPORT` <small>(line 11)</small> value in the `Scripts/aimt.lua` file.

By default, the scrip will automatically give any player an empty pistol. To change this, you can set the `GIVE_ALL_PLAYERS_WEAPONS` <small>(line 9)</small> value in the `Scripts/aimt.lua` file.
Disabling `ENABLE_AIM_TELEPORT` <small>(line 11)</small> wil also prevent players to get pistols too.

Finally, you can then use the exported `TeleportAtAimPoint` in any other ressources, granted that your server loads Aim Teleporter first.

## Controls ##

The controls are intuitive, and works just like your typical GTA controls.

| Input                                         | Controls      |
|-----------------------------------------------|---------------|
| <kbd>E</kbd> <small>(while aiming)</small>    |  Teleport     |

**_BEWARE_ THAT THE SCRIPT <big style="color:red">DOESN'T PREVENT</big>  PLAYERS FORM <big style="color:red" >TAKING DAMAGES</big> AFTER TELEPORTING. <big style="color:red">USE IT AT YOUR OWN RISK</big>**

## Exports ##

The resource also exports a `TeleportAtAimPoint` function that can be called to immediately teleport to the aiming position from any other resources.