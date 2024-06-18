#!/usr/bin/env zsh

# Get monitor setup.
mon_middle=$([[ -n ${CMONITORS[middle]} ]] && xrandr | pcre2grep -m1 -o1 '^('${CMONITORS[middle]%%:*}') connected')
mon_left=$([[ -n ${CMONITORS[left]} ]] && xrandr | pcre2grep -m1 -o1 '^('${CMONITORS[left]%%:*}') connected')
mon_right=$([[ -n ${CMONITORS[right]} ]] && xrandr | pcre2grep -m1 -o1 '^('${CMONITORS[right]%%:*}') connected')

if [ -n "$mon_middle" ]; then
  if [ -n "$mon_left" ]; then
    if [ -n "$mon_right" ]; then
      MONCOUNT=3
      MON1=$mon_middle
      MON2=$mon_left
      MON3=$mon_right
    else
      MONCOUNT=2
      MON1=$mon_middle
      MON2=$mon_left
    fi
  elif [ -n "$mon_right" ]; then
    MONCOUNT=2
    MON1=$mon_middle
    MON2=$mon_right
  else
    MONCOUNT=1
    MON1=$mon_middle
  fi
else
  dunstify -u critical -t 16000 "$(printf 'Xrandr Error in polybar launch.sh!\n\nUnable to load monitor layout to launch polybar:\nNo connected monitors detected!\n')"
fi

# Terminate already running bar instances.

# Terminate all Polybar processes by sending SIGKILL to each PID. After killing
# all Polybar processes, pgrep for any remanining Polybar instances and try
# sending other signals. Lastly, after trying everything, `pgrep` Polybar
# instances that are still running and wait until they're gone.
#
# Previous code for killing Polybar instances: `killall -q polybar`
# Above `killall` call sometimes leaves a frozen Polybar instance running for no
# clear reason why. SIGKILL (9) seems to always kill Polybar.
#
# `pgrep` Polybar instances that are running and try kill them with KILL(9)
# signal. If this doesn't work, try TERM(15), HUP(1) and QUIT(2) signals. Note
# that the $signals array indexes are off by +1.
for signal in KILL TERM HUP QUIT; do
	pgrep -u $UID -x polybar > >(
		while read pid; do kill -s $signal $pid; done
	) && sleep 0.5 || break
done

# Final `pgrep` for remaining Polybar instances, which should be terminating any
# second now; Wait in a while-loop until no Polybar processes are found.
while pgrep -u $UID -x polybar &>/dev/null; do sleep 0.5; done

# Path to the used configuration file.
cfg="$HOME/.config/polybar/docky/config.ini"
#cfg="$HOME/.config/polybar/dt-test/config.ini"

# Launch the bar.
case $MONCOUNT in
  1)
    polybar -q $MON1 -c "$cfg" &
    ;;
  2)
    polybar -q $MON1 -c "$cfg" &
    polybar -q $MON2 -c "$cfg" &
    ;;
esac
