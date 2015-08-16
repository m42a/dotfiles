# Make everything the right color
xrdb -merge ~/.Xresources
# Recheck all the fonts
xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/artwiz-fonts
xset fp rehash
# Enable ibus in applications
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
# No, I really don't want to use Xcursor
export XCURSOR_PATH=""
# Don't make the cursor a giant X
xsetroot -cursor_name left_ptr
# Make QT5 applications look like QT4 applications
export QT_STYLE_OVERRIDE=qt4
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

# Fix CVE-2012-0064
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
width=$(xrandr -q | sed -n 's/^.*[^0-9]\([0-9]*\)x[0-9]*+0+0.*$/\1/p')
while true; do date +%Y.%m.%d\ %a\ %T; sleep 1; done | dzen2 -e 'button2=;' -x $((width-150)) -w 150 -h 16 &
conky

# Use both the 32 and 64-bit ladspa plugins
export LADSPA_PATH=/usr/lib/ladspa:/usr/lib32/ladspa

# Add a connman tray icon
cmst --minimized &

pidgin &

ibus-daemon -rx &

ulimit -c unlimited

urxvt &

exec xmonad
