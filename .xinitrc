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
# Make AWT and SWING less terrible
export _JAVA_AWT_WM_NONREPARENTING=1
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

# Get the primary monitor attributes
read width height x_off y_off << EOF
$(xrandr -q | awk -f monitor-select.awk)
EOF

# Add the tray and date
stalonetray \
	--background "#121212" \
	--icon-size 16 \
	--icon-gravity NE \
	--geometry 6x1+$((x_off+width-246))+${y_off} \
	--max-geometry 6x1 \
	&
while true; do date +%Y.%m.%d\ %a\ %T; sleep 1; done | dzen2 -e 'button2=;' -x $((x_off+width-150)) -w 150 -y ${y_off} -h 16 &

# Newer versions of conky have xinerama support, and will position themselves relative to the primary monitor
conky -x 0 -y 0 &

# Use both the 32 and 64-bit ladspa plugins
export LADSPA_PATH=/usr/lib/ladspa:/usr/lib32/ladspa

# Add a connman tray icon
cmst --minimized &

pidgin &

# Don't let the screen sleep while I'm pressing controller buttons
joystickwake &

ibus-daemon -rx &

ulimit -c unlimited

urxvt &

xmonad --recompile
exec xmonad
