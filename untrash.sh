#!/bin/bash
logfile="$HOME/.trash.log"
found=""
while read -r line;
do
	path=$(echo "$line" | cut -d' ' -f1)
	filename=$(basename "$path")
	dirname=$(dirname "$path")
	link=$(echo "$line" | cut -d' ' -f2)
	if [[ "$filename" == "$1" ]]
	then
		read -p "$path? (y/n)" -n 1 -r < /dev/tty
		echo
		if [[ "$REPLY" == "y" ]]
		then
			found="$line"
			if [[ ! -d "$dirname" ]]
			then
				echo "Directory not found, recovering to $HOME/"
				dirname="$HOME"
			fi
			echo "$dirname/$filename"
			while true;
			do
				if [[ -f "$dirname/$filename" ]] || [[ -d "$dirname/$filename" ]]
				then
					read -p "Name confict! Rename or override? (r/o)" -n 1 -r < /dev/tty
					echo
					if [[ "$REPLY" == "r" ]]
					then
						read -p "Enter new name: " -r < /dev/tty
						filename="$REPLY"
					elif [[ "$REPLY" == "o" ]]
					then
						break
					fi
				else
					break
				fi
			done
			mv "$HOME/.trash/$link" "$dirname/$filename"
			break
		fi
	fi
done < "$logfile"

if [[ "$found" != "" ]]
then
	awk -v var="$line" '$0 != var { print $0 }' < "$logfile" > ".trash.temp"
	cat ".trash.temp" > "$logfile"
	rm ".trash.temp"
fi
