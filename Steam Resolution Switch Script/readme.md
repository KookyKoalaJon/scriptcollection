Here is my Script to set your display to your targeted games resolution, launch the game and change back after after games closes.
The script should work with most KDE wayland desktops, script was written on Nobara Linux, a Fedora Core based distro.


First we will need a couple of things
Game ID- from .desktop file
Game Window Title- from .desktop file
Snooze- This is the time it takes to launch the steam game.
Desktop Resolution – from display manager settings
Game Resolution – Supported resolutions under display manager settings
Return Scale – Return desktop to specific scale set
Refresh rate – Under display manager settings

## Note ##
To quickly get to your display manager settings, right-click your desktop and choose display manager.

Desktop File-
You can open applications menu, find the steam game you want under the games category and right click edit applications, or you can right click edit with kate if it is a desktop icon.

Download the Script (Github Link), and save it to somewhere safe ideally in a folder of its own I like to keep my scripts in $HOME/Scripts so mine is /home/user/Scripts/Game/steam_game_launch.sh.

1. Edit the script with Kate, and set your values in the top of the script
2. Save Script As, I like to use game_name_launch.sh
3. Right click the .sh choose properties, and make sure allow executing as a program is checked.
4. Double click, and check that lunch script works. It should change desktop to your target resolution, launch the game, after you close the game it should change the resolution of your desktop back to your set desktop resolution.
5. you can edit your .desktop file remove the command-line arguments and set the program launch to your new script to launch the game.


Example for Valheim, with a desktop resolution of 1440p  scaled at 120% and a game resolution of 1080p

##Steam Game ID
gameid=892970
##Output device ID, only needs changed if not your primary monitor.
outputdevice=1

## Game Window Title ## Game window title in quotes (this is normally the Name value in the desktop file)
gametitle="Valheim"

## Snooze time for game to launch, this may need to be adjusted to get in game.
Snooze=15

## Set the game res before launching you want here this will be your resolution@refreshrate see example below
resgame=1920x1080@165
## Set your return desktop resolution here
resdesk=2560x1440@165

## if you had your desktop scaled you can set it to return back to this scale 1.2 = 120%
returnscale=1.2
