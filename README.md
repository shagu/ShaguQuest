# ShaguQuest
ShaguQuest is a database Addon for World of Warcraft Vanilla (1.12.1) Clients.
It includes a huge amount of data which contains spawn,drop and quest stuff.

This data can be used to display all kind of informations on your map (Cartographer required).
The following command will display all "Gold Ores" on your map.
This can be used for all kind of NPCs or gameobjects too.

    /shagu spawn Gold Ore

If you are interested in displaying some drop informations, try out the following,
it will display all kind of mobs, treasures and so on which the item can be obtained from.

    /shagu item Black Pearl


Additionally ShaguQuest includes a (poor) quest integration via EQL3 (Extended QuestLog).
On every quest you'll see a "Show" button, which will display all known questrelated stuff on your map.
The "Clean" button removes every ShaguQuest note from the map.

Due to classic Wow-API restrictions, this Addon is only available for enGB and deDE clients.

It is based on the latest Mangos Zero Database, as well as GMDB.
Some parts of the Addon itself are taken from the WHDB Addon.

# Video
If you want to see it in Action, here is a example video, showing the most common features of ShaguQuest

[![Youtube Video](http://img.youtube.com/vi/h_U3vbYcRpE/0.jpg)](https://www.youtube.com/watch?v=h_U3vbYcRpE)

# Download
If you want to test it, visit the following links:

[Official Website](http://shaguquest.ericmauser.de/)

[Download of enGB Client](http://shaguquest.ericmauser.de/files/ShaguQuest-4.1-enGB-complete.zip)

[Download of deDE Client](http://shaguquest.ericmauser.de/files/ShaguQuest-4.1-deDE-complete.zip)

# Build from git
If you're running a Linux Machine, just execute the "./build.sh" to create a deDE and enGB release.
The files will be placed in ./releases called ShaguQuest-<version>-<locale>-complete.zip
