#!/bin/bash
##Steam Game ID
gameid=892970
## Target Monitor Output ID
outputdevice=1
## Game Window Title ##
gametitle="Valheim"
## Snooze time for game to launch
snooze=15
resgame=1920x1080@165
resdesk=2560x1440@165
function ScreenRes1080p () {
kscreen-doctor output.1.mode.$resgame output.$outputdevice.scale.1
}
function ScreenRes1440p () {
kscreen-doctor output.1.mode.$resdesk output.$outputdevice.scale.1.2
}

echo "Seting resolution, to 1080"
ScreenRes1080p
echo "Launching $gametitle"
steam steam://rungameid/$gameid
echo "Sleeping to wait for game to launch"
sleep $snooze
echo "Game, should be launched"
while pgrep -f "$gametitle" > /dev/null; do
    sleep 10
done
echo "Game has Closed!"
echo "Seting resolution, back to 1440p "
ScreenRes1440p
