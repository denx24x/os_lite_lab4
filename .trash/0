#!/bin/bash

last="$HOME/.trash/last.data"

if [[ !  -d "$HOME/.trash" ]]
then
	mkdir "$HOME/.trash"
	echo "0" > "$last"
fi
index=$(cat "$last")
link "$1" "$HOME/.trash/$index"

echo "$PWD/$1 $index" >> "$HOME/.trash.log"

index=$(( $index + 1 ))
echo "$index" > "$last"

rm $1
