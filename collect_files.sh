#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Использование: $0 /path/to/input_dir /path/to/output_dir"
    exit 1
fi

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
    echo "Входная директория не существует: $input_dir"
    exit 1
fi

mkdir -p "$output_dir"

declare -A name_count

find "$input_dir" -type f | while read -r filepath; do
    filename="$(basename "$filepath")"
    if [[ -e "$output_dir/$filename" || ${name_count["$filename"]+_} ]]; then
        count=$(( ${name_count["$filename"]:-1} + 1 ))
        name_count["$filename"]=$count
        ext="${filename##*.}"
        base="${filename%.*}"
        if [[ "$base" == "$filename" ]]; then
            newname="${base}_${count}"
        else
            newname="${base}_${count}.${ext}"
        fi
        cp "$filepath" "$output_dir/$newname"
    else
        name_count["$filename"]=0
        cp "$filepath" "$output_dir/$filename"
    fi
done
