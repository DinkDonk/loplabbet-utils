#! /bin/bash

# Check dependency requirements -->
if ! command -v pandoc &> /dev/null
then
	echo "Pandoc not found. Please install it: `$ brew install pandoc`"
	exit
fi

if ! command -v htmlq &> /dev/null
then
	echo "Htmlq not found. Please install it: `$ brew install htmlq`"
	exit
fi
# <--

# Main -->
WHITE='\033[0;97m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Style reset

spin=("⣾" "⣽" "⣻" "⢿" "⡿" "⣟" "⣯" "⣷")

showLoader() {
	local pid=$1
	i=0
	while kill -0 $pid 2>/dev/null
	do
		i=$(( (i+1) %8 ))
		printf "\r${spin[$i]} "
		sleep .1
	done
	printf "\r${GREEN}✔${NC}"
}

outputName=${PWD##*/}

rm text.csv

echo "title|ingress|text" > "text.csv"

for file in *.docx; do
	echo -ne "  ${WHITE}Converting${NC} $file" &
	pid=$!
	showLoader $pid

	html=$(pandoc "${file}" -t html)
	title=$(echo $html | htmlq 'p:first-child>strong' | sed -e "s/^<strong>//" -e "s/<\/strong>$//")
	ingress=$(echo $html | htmlq 'p:not(:first-child)>strong' | sed -e "s/^<strong>/<p>/" -e "s/<\/strong>$/<\/p>/")
	text=$(echo $html | htmlq -r 'p>strong' | htmlq 'p:not(:empty)')
	echo "\""${title}\""|\""${ingress}\""|\""${text}\""" >> "${outputName}.csv"

	echo
done
# <--
