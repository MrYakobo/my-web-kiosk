# my-web-kiosk

this is my personal guide to setting up a web-based kiosk on a raspberry pi 3b.
it's *very much* based on [chilipie-kiosk](https://github.com/jareware/chilipie-kiosk/tree/master), but with instructions for doing it on the latest raspbian 64-bit image.
i take no responsibility for ease of use, or anything like that. this is documentation for myself in 4 years, when it's time to update raspbian again.

## prep-step 1: flash the image

[Use raspberry pi imager][1] to flash [raspbian 64-bit GUI][2] on a blessed sdcard

[1]: https://www.raspberrypi.com/software/
[2]: https://www.raspberrypi.com/software/operating-systems/#:~:text=Archive-,Raspberry%20Pi%20OS%20(64%2Dbit),-Compatible%20with%3A

## prep-step 2: make sure you can SSH to the pi and set url

copy the files

- /boot/userconf.txt (to login over ssh with username pi, password raspberry)
- /boot/ssh (enable ssh)
- /boot/chilipie_url.txt
- /etc/NetworkManager/system-connections/wifi.nmconnection (if you're deploying the pi on wifi. edit the file with your wifi credentials. also, might as well replace the UUID with a new one)

## live-step 1: boot up the pi and hope for the best

it really takes around 5 minutes to resize partitions or something. so, grab a coffee and wait.
i force-rebooted the pi a couple of times due to insufficent patience.
also, don't forget that (by default) a screensaver will blank the screen after some minutes, so don't be too generous with your patience

## live-step 2: install some needed packages

```bash
sudo apt install vim fish x11vnc xdotool nitrogen unclutter cec-utils jq
```

## live-step 3: copy the autostart files

- /home/pi/autostart.sh
- /home/pi/.config/lxsession/LXDE-pi/autostart
- /home/pi/turn_on_tv_and_set_channel.sh
- /home/pi/turn_off_tv.sh

## live-step 4: edit the crontab to your liking

```bash
crontab -e
```

my crontab below

```
DISPLAY=:0

# Reboot the Pi every sunday morning at 9 AM to ensure smooth operation
0 9 * * 0 sudo reboot

# turn off display at sundays, 14PM
0 14 * * 0 bash turn_off_tv.sh
```

## step 5: reboot and profit

hopefully this didn't take too long to do