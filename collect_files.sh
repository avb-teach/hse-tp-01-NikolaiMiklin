#!/bin/sh

a() {
  [ $# -lt 2 ] && echo "Use: $0 [--d N] X Y" >&2 && return 1
  local b=0 c d e f g h i j k l m n o p q r s t u v w x y z
  [ "$1" = "--d" ] && b=$2 && shift 2
  c=$1 d=$2
  [ ! -e "$c" ] && echo "Missing X: $c" >&2 && return 1
  mkdir -p "$d"
  e() {
    local f=$1 g=$2 h=$3
    [ $b -ne 0 ] && [ $h -gt $b ] && return
    for i in "$f"/*; do
      if [ -f "$i" ]; then
        j=${i##*/}
        k=${j%.*}
        l=${j##*.}
        [ "$k" = "$l" ] && l="" || l=".$l"
        m=1
        n="$j"
        while [ -e "$g/$n" ]; do
          n="${k}${m}${l}"
          m=$((m + 1))
        done
        cp "$i" "$g/$n"
      elif [ -d "$i" ]; then
        e "$i" "$g" $((h + 1))
      fi
    done
  }
  e "$c" "$d" 0
  echo "Done: $d" >&2
}

a "$@"
