#!/bin/bash
date=$(date '+%Y-%m-%d')
found=""
home="/home/user"
source="$home/source"
for entry in $(ls "$home")
do
	if [[ ! -d "$home/$entry" ]]
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
	mkdir "$home/Backup-$date"
	filelist=$(find "$source")
	cp -r "$source/." "$home/Backup-$date"
	echo "$date: Created backup $home/Backup-$date" >> "$home/backup-report"
	echo "$filelist" >> "$home/backup-report"
else
	echo "$date: backup Backup-$date updated" >> "$home/backup-report"
	for file in $(find "$source")
	do
		if [[ "$file" == "$source" ]]
		then
			continue
		fi
		localpath=${file#"$source"}
		if [[ -d "$file" ]]
		then
			if [[ ! -d "$home/$found$localpath" ]]
			then
				mkdir "$home/$found$localpath"
				echo "dir $localpath created"
			fi
		else
			if [[ -f "/home/user/$found$localpath" ]]
			then
				size1=$(stat --printf="%s" "$file")
				size2=$(stat --printf="%s" "$home/$found$localpath")
				if (( size1 != size2 ))
				then
					mv "$home/$found$localpath" "$home/$found$localpath-$date"
					cp "$file" "$home/$found$localpath"
					echo "$localpath replaced, old renamed to $localpath-$date"
				fi
			else
				cp "$file" "$home/$found$localpath"
				echo "$localpath copied"
			fi
		fi
	done >> "/home/user/backup-report"
fi




