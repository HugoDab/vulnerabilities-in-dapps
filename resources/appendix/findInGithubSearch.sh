#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Search for a string inside every git repositories from a search in github."
  echo
  echo "Syntax: findInGithubSearch [-f|h|l|o] query"
  echo "options:"
  echo "f     File with previous github link you don't want to search in."
  echo "h     Print this Help."
  echo "l     Specify a language."
  echo "o     Output file (mandatory)."
}

############################################################
# Process the input options.                               #
############################################################

while getopts "f:h:l:o:" option; do
  case $option in
  f) # file with link to search in
    fileNotToSearch=$OPTARG
    ;;
  h) # display Help
    Help
    exit
    ;;
  l) # file with link to search in
    language=$OPTARG
    ;;
  o) # output file
    outputFile=$OPTARG
    ;;
  \?) # Invalid option
    echo "Error: Invalid option"
    exit
    ;;
  esac
done

shift "$((OPTIND - 1))"

if [ -z "$1" ]; then
  echo 'Missing query argument' >&2
  Help
  exit 1
fi

if [ -z "$outputFile" ]; then
  echo 'Missing -o option' >&2
  Help
  exit 1
fi

############################################################
# Main program                                             #
############################################################

removeFirstLine() {
  tail -n +2 "$1" >"$1.tmp" && mv "$1.tmp" "$1"
}

workdir=$(pwd)

"$workdir"/scripts/bash/searchRepo.sh -o tmpSearch.txt -l "$language" "$1"

removeFirstLine tmpSearch.txt

if [ -z "$fileNotToSearch" ]; then
  cat tmpSearch.txt >tmpMerge.txt
else
  "$workdir"/scripts/bash/mergeFile.sh -o tmpMerge.txt tmpSearch.txt "$fileNotToSearch"
fi

"$workdir"/scripts/bash/finderGithub.sh -j -o tmpFinder.txt tmpMerge.txt

removeFirstLine tmpFinder.txt

"$workdir"/scripts/bash/getName.sh -o tmpNames.txt tmpMerge.txt

python3 "$workdir"/scripts/python/match_to_csv.py tmpFinder.txt tmpMatch.csv
python3 "$workdir"/scripts/python/add_name_link_to_search_result.py tmpNames.txt tmpMerge.txt tmpMatch.csv "$outputFile"

rm "$workdir"/tmpMerge.txt
rm "$workdir"/tmpSearch.txt
rm "$workdir"/tmpNames.txt
rm "$workdir"/tmpMatch.csv
rm "$workdir"/tmpFinder.txt
