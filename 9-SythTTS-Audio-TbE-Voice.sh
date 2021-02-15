#!/bin/bash
. cfg.sh
#
var=${1:?You have to provide an EDB text filename with no spaces as an argument}
# Creates a timestamp for the directory name
timestamp=$(date +%m%d%y-%H%M%S)
# Creates a folder with a name composed of the timestamp and the text file argument
mkdir $timestamp$1
cp $1 ./$timestamp$1
#
# Storing the JSON file containing the speaker ID into a variable
speaker_json=`ls -1 *.json`
#
while IFS= read -r line
	do
		# Extract audio filename from EDB file
		prompt_audio=`echo $line|cut -f1 -d:` &&
		# Extract audio basename to be used as the TTS prompt name
		prompt_name=$(basename "$prompt_audio" .wav) &&
		# Extract Speaker Model ID from JSON file
		echo "Generating audio file " $prompt_audio-tbe.wav " using prompt " $prompt_name "............" &&
	  curl -X POST -u $useCred --header "Content-Type: application/json" --header "Accept: audio/wav" --data "{\"text\":\"<ibm:prompt id='$prompt_name'/>\"}" --output ./$timestamp$1/$prompt_name-tbe.wav "$url/v1/synthesize?customization_id=$customID&voice=$voice"

	done < "$1"