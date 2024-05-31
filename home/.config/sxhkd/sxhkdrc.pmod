##==================================================================================================
##== PMOD
##==================================================================================================
#region PMOD

# focus and follow the next/previous window in the current desktop with mouse
{button9,button8}
  bspc node -f '{next,prev}.local.!hidden.window'
# move window to main monitor with keypad enter
KP_Enter
	bspc node -d ^'{4}' --follow
# move window to second monitor with keypad plus
KP_Add
	bspc node -d ^'{10}' --follow
# close focused window with numpad minus
KP_Subtract
	bspc node -c
# kill mouseover item on middle click
#button2
#  bspc node -c
# set window tiled, or from tiled to float, with mouse middle button
#button2
#	[ -z "$(bspc query -N -n focused.tiled)" ] \
#		&& bspc node focused -t tiled \
#		|| bspc node focused -t floating

#endregion

##==================================================================================================
##== System Keybindings
##==================================================================================================
#region System Keybindings

# restart or quit bspwm
super + alt + {_,shift + ctrl + }r
  bspc {wm -r,quit}
# reload sxhkd keybind configuration files
super + alt + y
  pkill -USR1 -x sxhkd
# power menu (previously: super + alt + t)
super + 0
  ~/.config/rofi/powermenu.sh
# Lock the window using modified i3lock-fancy.sh in ~c/bin.
super + 9
  ~/.src/repos/2c-usercfg/home/.config/bspwm/scripts/i3lock-fancy-dualmon

#endregion

##==================================================================================================
##== Rofi Menus
##==================================================================================================
#region Rofi Menus

# rofi: program launcher
super + less
  rofi -modi drun -show drun -line-padding 4 \
    -columns 2 -padding 50 -hide-scrollbar -terminal xfce4-terminal \
    -show-icons -drun-icon-theme "Arc-X-D" -font "Droid Sans Regular 10"
# rofi: show open windows
super + shift + greater
  rofi -modi drun -show window -line-padding 4 \
    -columns 2 -padding 50 -hide-scrollbar -terminal xfce4-terminal \
    -show-icons -drun-icon-theme "Arc-X-D" -font "Droid Sans Regular 10"
# rofi: show sxhkd keybindings
super + ctrl + less
  ~/.config/rofi/keybindings.sh
# rofi: generate a long mpwd password using 'mpwdp'
super + ctrl + {_,alt} + p
  mpwdp {long,maximum}

#endregion

##==================================================================================================
##== Application Launches
##==================================================================================================
#region Application Launches

# terminal emulator: alacritty
super + Return
  alacritty
# terminal emulator: xfce4-terminal
super + alt + Return
  xfce4-terminal
# vscodium (main .ddm environment)
super + q
  vscodium --no-sandbox
# doom emacs client
super + alt + q
  emacsclient -c -a 'emacs'
# firefox
super + w
  librewolf
# firefox profile selector
super + ctrl + w
  librewolf -P
# chromium
super + alt + w
  chromium
# file manager (thunar)
super + e
  thunar

#endregion

##==================================================================================================
##== Focus
##==================================================================================================
#region Focus

# focus the previous node/desktop
super + {_,alt + }b
  bspc {node,desktop} -f last
# focus the next/previous window in the current desktop
super + {_,shift + }Tab
  bspc node -f {next,prev}.local.!hidden.window
# focus the next/previous desktop in the current monitor
super + ctrl + {_,shift + }Tab
  bspc desktop -f {next,prev}.local
# focus or shift to the node in the given direction
super + {_,shift + }{Left,Down,Up,Right}
  bspc node -{f,s} {west,south,north,east}
# focus the given desktop
super + {a,s,d,z,x,c}
  bspc desktop -f '^{1,2,3,4,5,6}'
# focus the given desktop on second monitor
super + alt + {a,s,d,z,x,c}
  bspc desktop -f '^{7,8,9,10,11,12}'

#endregion

##==================================================================================================
##== Window Status
##==================================================================================================
#region Window Status

# close or kill the focused window
super + {_,alt + }g
  bspc node -{c,k}
# alternate between the tiled and monocle layout
super + v
  bspc desktop -l next
# set window tiled, or from tiled to float
super + n
  [ -z "$(bspc query -N -n focused.tiled)" ] \
    && bspc node focused -t tiled \
    || bspc node focused -t floating
# set window fullscreen, or return to tiled
super + f
  [ -z "$(bspc query -N -n focused.fullscreen)" ] \
    && bspc node focused -t fullscreen \
    || bspc node focused -t tiled
# expand a window by moving one of its side outward
super + alt + {Left,Down,Up,Right}
  bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}
# contract a window by moving one of its side inward
super + ctrl + alt + {Left,Down,Up,Right}
  bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}
# send to the given desktop and focus that desktop
super + ctrl + {a,s,d,z,x,c}
  bspc node -d '^{1,2,3,4,5,6}' --follow
# send to the given desktop on second monitor and focus that desktop
super + alt + ctrl + {a,s,d,z,x,c}
  bspc node -d '^{7,8,9,10,11,12}' --follow
# send to the given desktop without focusing it
super + shift + {a,s,d,z,x,c}
  bspc node -d '^{1,2,3,4,5,6}'
# send to the given desktop on second monitor without focusing it
super + alt + shift {a,s,d,z,x,c}
  bspc node -d '^{7,8,9,10,11,12}'
# preselect the splitting direction
super + ctrl + {Left,Down,Up,Right}
  bspc node -p {west,south,north,east}
# cancel all splitting preselections in the focused desktop
super + ctrl + space
  bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

#endregion

##==================================================================================================
##== Screenshots
##==================================================================================================
## If xfce4-screenshooter still whines, modify:
## ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
## /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
##==================================================================================================
#region Screenshots

# screenshot to file - Mod: (None)Window (Super)Select (Shift)Everything
{_,super,shift} + Print
  scrot {-u,-s,_} '/home/dxo/Pictures/ss-$a-%y%m%d-%H%M%S-$wx$h.png'
# screenshot to clipboard - Mod: (Ctrl+) (None)Window, (Super)Select, (Shift)Everything
ctrl + {_,super,shift} Print
  scrot {-u,-s,_} '/tmp/ss-$a-%y%m%d-%H%M%S-$wx$h.png' -e 'xclip -se c -t image/png $f; rm -f $f; notify-send -t 5000 "Screenshot copied to clipboard."'

#endregion

##==================================================================================================
##== Miscallenous
##==================================================================================================
#region Miscallenous

# increase volume by 2%
XF86AudioRaiseVolume
  pactl set-sink-volume @DEFAULT_SINK@ +1000
# decrease volume by 2%
XF86AudioLowerVolume
  pactl set-sink-volume @DEFAULT_SINK@ -1000
# toggle volume mute
XF86AudioMute
  amixer -q -D pulse sset Master toggle

#endregion
