# ShaguDB
ShaguDB is a database Addon for World of Warcraft Vanilla (1.12.1) Clients.
It includes a huge amount of data which contains spawn,drop and quest stuff.

This data can be used to display all kind of informations on your map (Cartographer required).
The following command will display all "Gold Ores" on your map.
This can be used for all kind of NPCs or gameobjects too.

		/shagu spawn Gold Ore

If you are interested in displaying some drop informations, try out the following,
it will display all kind of mobs, treasures and so on which the item can be obtained from.

		/shagu item Black Pearl

With version 5.0 a new feature was introduced. The "vendor" command.

		/shagu vendor Jagged Arrow

Will display all vendors selling "Jagged Arrow".

Additionally ShaguDB includes a (poor) quest integration via ShaguQuest (Extended QuestLog).
On every quest you'll see a "Show" button, which will display all known questrelated stuff on your map.
The "Clean" button removes every ShaguDB note from the map.

Due to classic Wow-API restrictions, this Addon is only available for enGB and deDE clients.

It is based on the latest Mangos Zero Database, as well as GMDB.
Some parts of the Addon itself are taken from the WHDB Addon. ShaguQuest is basically EQL3 with a few modifications.

# Video
If you want to see it in Action, here is a example video, showing the most common features of ShaguDB

[![Youtube Video](https://img.youtube.com/vi/SYrCEI_2Axg/0.jpg)](https://www.youtube.com/watch?v=SYrCEI_2Axg)

# Download
If you want to check it out, visit one of the following links:

[Official Website](http://shagu.org/shaguquest/)

[Github Releases](https://github.com/shagu/ShaguQuest/releases)

# Build it Yourself
If you're running a Linux Machine:
    
    $ git clone https://github.com/shagu/ShaguQuest
    $ cd ShaguQuest
    $ make
    
After that, all Addons will be built and can then be found in the directory: _./releases_
