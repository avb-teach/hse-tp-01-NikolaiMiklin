#!/bin/bash

[ $# -lt 2 ] || [ $# -gt 3 ] && { echo "error"; exit 1; }

depth=""
from=""
to=""

if [ "$1" = "--depth" ]; then
    [ $# -ne 4 ] && { echo "error"; exit 1; }
    depth=$2
    from=$3
    to=$4
else
    [ $# -ne 2 ] && { echo "error"; exit 1; }
    from=$1
    to=$2
fi

[ ! -d "$from" ] && { echo "error"; exit 1; }
mkdir -p "$to" || { echo "error"; exit 1; }

cp_file() {
    local src=$1
    local base=$(basename "$src")
    local dst="$to/$base"
    local count=1

    while [ -f "$dst" ]; do
        name=${base%.*}
        ext=${base##*.}
        [ "$name" = "$ext" ] && dst="$to/${base}_$count" || dst="$to/${name}_$count.$ext"
        ((count++))
    done

    cp "$src" "$dst" || echo "error" >&2
}

walk() {
    local dir=$1
    local level=$2

    [ -n "$depth" ] && [ "$level" -gt "$depth" ] && return

    for item in "$dir"/*; do
        [ -f "$item" ] && cp_file "$item"
        [ -d "$item" ] && walk "$item" $((level+1))
    done
}

walk "$from" 1
