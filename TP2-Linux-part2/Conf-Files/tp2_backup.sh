#!/bin/bash

# Siple backup script
# Adam 09/10/2021

# colors

N="\e[0m"
B="\e[1m"
G="\e[32m"
R="\e[31m"
Y="\e[33m"

usage() {
	name=$0
	echo -e "${Y}usage:${N} $name destination target"
	echo "	destination	Path to the directory which stores backups"
	echo "	target		Path to the directory you want to backup"
	exit 1
}

# options handling
while getopts "hk:" OPTION; do
	usage
done
shift $((OPTIND-1))

if [[ -z $1 || -z $2 ]] ; then
	>&2 echo -e "${R}[ERROR]${N} you must specify a destination and a target.\n"
	usage
fi

#global variables
dest=$1
target=$2
backup_name="tp2_backup_"$(date +%Y%m%d-%H%M%S)".tar.gz"
backup_fullpath="$(pwd)/${backup_name}"

# Checks that must be run before creating the backup
prerun_checks(){
	if [[ $(id -u) -ne 0 ]] ; then
		>&2 echo -e "${R}[ERROR]${N} This script must be run as root."
		exit 1
	fi

	if ! command -v rsync &> /dev/null ; then
		>&2 echo -e "${R}[ERROR]${N} Command rsync not found."
		exit 1
	fi

	if [[ ! -d $dest ]] ; then
		>&2 echo -e "${R}[ERROR]${N} Directory ${dest} is not accessible."
		exit 1
	fi

	if [[ ! -d $target && ! -f $target ]] ; then
		>&2 echo -e "${R}[ERROR]${N} Target ${target} is not accessible."
		exit 1
	fi
}

# archive + compress $dir_to_archive
archive_and_compress() {
	dir_to_archive=$1
	tar cvzf "${backup_fullpath}" "${dir_to_archive}" &> /dev/null
	status=$?
	if [[ $status -eq 0 ]] ; then
		echo -e "${G}[OK]${N} archive ${backup_fullpath} created."
	else
		>&2 echo -e "${R}[ERROR]${N} creation of archive ${backup_fullpath} failed. (trying to archive ${dir_to_archive})"
		exit 1
	fi
}

# Synchronize $dir_to_archive into $destination directory
sync(){
	rsync -av --remove-source-files "${backup_fullpath}" "${dest}" &> /dev/null
	status=$?
	if [[ $status -eq 0 ]] ; then
		echo -e "${G}[OK]${N} Archive ${backup_fullpath} synchronized to ${dest}."
	else
		>&2 echo -e "${R}[ERROR]${N} Synchronization of ${backup_fullpath} to ${dest} failed."
		exit 1
	fi
}

# Code
prerun_checks
archive_and_compress "${target}"
sync
