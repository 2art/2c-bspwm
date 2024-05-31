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
killall -q polybar
sleep 1
#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

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
