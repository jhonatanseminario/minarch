#!/bin/sh

xrdb -merge ~/.Xresources
setxkbmap latam

xinput set-prop "FTCS0038:00 2808:0101 Touchpad" "libinput Natural Scrolling Enabled" 1

picom &
slstatus &
feh --bg-scale ~/.config/wallpaper.bmp &
flameshot &
copyq &
xss-lock -- sh -c 'playerctl pause; slock' &

while true; do
  BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
  STATUS=$(cat /sys/class/power_supply/BAT0/status)
  if [ "$BATTERY" -le 5 ] && [ "$STATUS" = "Discharging" ]; then
    alacritty -e sh -c "printf 'Batería al ${BATTERY}%%\nConecta el cargador, crack.\n'; read" &
  fi
  sleep 60
done &

xidlehook \
  --timer 300 \
    'CURRENT=$(brightnessctl get); echo $CURRENT > /tmp/brightness_backup; brightnessctl set $((CURRENT / 2))' \
    'brightnessctl set $(cat /tmp/brightness_backup)' \
  --timer 300 \
    'playerctl pause; slock' \
    'brightnessctl set $(cat /tmp/brightness_backup)' \
  --timer 300 \
    'systemctl suspend' \
    'brightnessctl set $(cat /tmp/brightness_backup)' &

/usr/lib/xdg-desktop-portal-gtk &

exec dwm
