#!/bin/bash

export DISPLAY=:0

# Start cursor at the top-left corner, as opposed to the default of dead-center
# (so it doesn't accidentally trigger hover styles on elements on the page)
xdotool mousemove 0 0

# Set some useful X preferences
xset s off # don't activate screensaver
xset -dpms # disable DPMS (Energy Star) features.
xset s noblank # don't blank the video device

# Set X screen background
sudo nitrogen --set-centered background.png

# Hide cursor afer 5 seconds of inactivity
unclutter -idle 5 -root &

# Make sure Chromium profile is marked clean, even if it crashed
if [ -f .config/chromium/Default/Preferences ]; then
    cat .config/chromium/Default/Preferences \
        | jq '.profile.exit_type = "SessionEnded" | .profile.exited_cleanly = true' \
        > .config/chromium/Default/Preferences-clean
    mv .config/chromium/Default/Preferences{-clean,}
fi

# Remove notes of previous sessions, if any
find .config/chromium/ -name "Last *" -exec rm {} +

# wait for internet to fully initalize
# not needed with good internet
sleep 5

# Start and detach Chromium
# http://peter.sh/experiments/chromium-command-line-switches/
# Note that under matchbox, starting in full-screen without a window size doesn't behave well when you try to exit full screen (see https://unix.stackexchange.com/q/273989)
# also, disable hw acceleration

URL=""
if [ -f /boot/chilipie_url.txt ]; then
    URL="$(head -n 1 /boot/chilipie_url.txt)"
elif [ -f /home/pi/chilipie_url.txt ]; then
    URL="$(head -n 1 /home/pi/chilipie_url.txt)"
fi
if [ -n "$URL" ]; then
    SERIAL="$(cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2 | xargs)" # Get serial number
    URL="$(echo $URL | SERIAL=$SERIAL envsubst '$SERIAL')"
fi

chromium-browser \
	--disable-gpu \
	--disk-cache-dir=/tmp/chromium \
	--start-fullscreen \
	--window-size=1920,1080 \
	--disable-infobars \
	"$URL" \
	&

bash turn_on_tv_and_set_channel.sh