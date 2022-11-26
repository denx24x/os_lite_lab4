#!/bin/bash
found=""
for entry in $(ls "/home/user/")
do
	if [[ ! -d "/home/user/$entry" ]]
	then
		continue
	fi
	if [[ ! "$entry" =~ Backup-[0-9]{4}-[0-9]{2}-[0-9]{2} ]]
	then
		continue
	fi

	year=$(echo "$entry" | cut -d'-' -f2)
	month=$(echo "$entry" | cut -d'-' -f3)
	day=$(echo "$entry" | cut -d'-' -f4)

	dif=$(( ($(date -d "$date UTC" '+%s') - $(date -d "$year-$month-$day UTC" '+%s')) / (60*60*24) ))

	if (( dif < 7 ))
	then
		found="$entry"
		break
	fi
done
if [[ "$found" == "" ]]
then
	echo "backup not found!"
	exit
fi
if [[ ! -d "/home/user/restore" ]]
then
	mkdir "/home/user/restore"
fi
for file in $(find "/home/user/$found")
do
	localpath=${file#"/home/user/$found"}
	if [[ "$localpath" == "" ]]
	then
		continue
	fi
	if [[ -d "$file" ]]
	then
		mkdir "/home/user/restore$localpath"
		continue
	fi
	name=$(basename "$file")
	dir=$(dirname "$file")
	if [[ "$name" =~ .*-[0-9]{4}-[0-9]{2}-[0-9]{2} ]]
	then
		continue
	else
		cp "$file" "/home/user/restore$localpath"
	fi
done

