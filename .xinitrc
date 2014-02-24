# Make everything the right color
xrdb -merge ~/.Xresources
# Don't make the cursor a giant X
xsetroot -cursor_name left_ptr
# Turn numlock on
numlockx
# Enable the volume keys
xbindkeys
# Make the mouse accelerate faster
xset m 19/10 0
# Make the mouse slower
~/razer_accel.sh
# Disable the trackpad for a half-second after hitting a key
syndaemon -i .5 -R -t -k -d
# Lock the screen after 11 minutes of inactivity
xscreensaver &
# Recheck all the fonts
xset +fp /usr/share/fonts/local
xset fp rehash

# Fix stupid X vulnerability
xmodmap -e "keycode  63 = KP_Multiply KP_Multiply KP_Multiply KP_Multiply KP_Multiply KP_Multiply NoSymbol"
xmodmap -e "keycode 106 = KP_Divide KP_Divide KP_Divide KP_Divide KP_Divide KP_Divide NoSymbol"

# Swap KP_2 and KP_5 when numlock is off
xmodmap -e "keycode  88 = KP_Begin KP_2 KP_Begin KP_2"
xmodmap -e "keycode  84 = KP_Down KP_5 KP_Down KP_5"

# Make the clipboard and primary selection merge
autocutsel -fork
autocutsel -selection PRIMARY -fork

# Add the tray and date
trayer --heighttype pixel --height 16 --widthtype pixel --width 100 --edge top --alpha 0 --transparent true --tint 0x121212 --align right --margin 150 &
while true; do date +%Y.%m.%d\ %a\ %T; sleep 1; done | dzen2 -e 'button2=;' -x 1450 -w 150 -h 16 &
conky

# Add a wicd tray icon
wicd-gtk -t &

pidgin &

ulimit -c unlimited

urxvt &

exec xmonad

