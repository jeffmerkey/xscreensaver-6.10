#!/bin/bash
# Copyright © 2025 Jamie Zawinski <jwz@jwz.org>
#
# Permission to use, copy, modify, distribute, and sell this software and its
# documentation for any purpose is hereby granted without fee, provided that
# the above copyright notice appear in all copies and that both that
# copyright notice and this permission notice appear in supporting
# documentation.  No representations are made about the suitability of this
# software for any purpose.  It is provided "as is" without express or 
# implied warranty.
#
# Created: 21-Jun-2025.

version="$Revision: 1.01 $";

verbose=false
export PATH="/usr/libexec/xscreensaver:$PATH"
CMD="xscreensaver-gfx"

D="/var/run/user/$UID"
if [ -d "$D"/. ]; then
  PIDDIR="$D"
else
  D="$HOME/tmp"
  if [ -d "$D"/. ]; then
    PIDDIR="$D"
  elif ! [ -z "$TMPDIR" ]; then
    PIDDIR="$TMPDIR"
  else
    PIDDIR="/tmp"
  fi
fi

PIDFILE="$PIDDIR/xscreensaver-gfx.pid"

verbose=false

while [ "$#" -gt 0 ]; do
  case $1 in
    --verbose|-verbose|-v)
      verbose=true
      CMD="$CMD --verbose"
      ;;
    --start)
      xscreensaver-gfx &
      PID="$!"
      if $verbose ; then echo "$0: launched $CMD in pid $PID" >&2 ; fi
      echo "$PID" > "$PIDFILE"
      ;;
    --stop)
      if ! [ -s "$PIDFILE" ]; then
        echo "$0: no pid in $PIDFILE" >&2
        exit 1
      fi
      PID=`cat "$PIDFILE"`
      rm "$PIDFILE"
      if $verbose ; then echo "$0: killing $PID" >&2 ; fi
      kill "$PID"
      ;;
    *)
      echo "usage: $0 --start | --stop"
      exit 1
      ;;
  esac
  shift
done

exit 0
