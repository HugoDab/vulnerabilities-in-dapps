#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Search for a string inside every git repository from list."
  echo
  echo "Syntax: finderGithub [-h|j|o|s] repoFile"
  echo "options:"
  echo "h     Print this Help."
  echo "j     Search for signTypedData, eth_sign and personal_sign in TS and JS files."
  echo "o     Output file."
  echo "s     Search for sign and ecrecover in Solidity files "
}

############################################################
# Process the input options.                               #
############################################################

while getopts "h:jo:s" option; do
  case $option in
  h) # display Help
    Help
    exit
    ;;
  j) # search in JS and TS
    regNum=1
    ;;
  o) # output file
    outputFile=$OPTARG
    ;;
  s) # search in solidity
    regNum=2
    ;;
  \?) # Invalid option
    echo "Error: Invalid option"
    exit
    ;;
  esac
done

shift "$((OPTIND - 1))"

if [ -z "$1" ]; then
  echo 'Missing repoFile argument' >&2
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

workdir=$(pwd)

if [ -z "$regNum" ]; then
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "| Search for:                                                          |"
  echo "|    1: SignTypedData, eth_sign and personal_sign in TS and JS files   |"
  echo "|    2: Sign and ecrecover in Solidity files                           |"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

  read -r regNum
fi

if [ "$regNum" -eq 2 ]; then
  stringToSearch="sig(n|nature)"
  stringToSearch2="ecrecover"
  fileRegex="*.sol"
  fileRegexExclude=":!node_modules/**"
  fileRegexExclude2=":!build/**"
  echo "Results for $stringToSearch and $stringToSearch2" >"$outputFile"
else
  stringToSearch="signTypedData"
  stringToSearch2="eth_sign"
  stringToSearch3="personal_sign"
  stringToSearch4="signTypedData_V1"
  stringToSearch5="signTypedData_V3"
  stringToSearch6="signTypedData_V4"
  fileRegex="*.[tj]s"
  fileRegexExclude=":!node_modules/**"
  fileRegexExclude2=":(attr:!vendored)*.js"
  echo "Results for $stringToSearch, $stringToSearch2 and $stringToSearch3" >"$outputFile"
fi

echo ""

nbLines=$(wc -l <"$1")
counter=1

while read -r repolink; do
  repoTemp=$(echo "$repolink" | cut -d '/' -f 4-5)
  repo=$(echo "$repoTemp" | cut -d '.' -f 1)

  echo "======================================="
  echo "Searching in $repo ~ ($counter/$nbLines)"

  echo "======================================= $repo =======================================" >>"$outputFile"

  git clone -q "https://:@github.com/$repo" "$workdir/tmpGitRepo"
  cd "$workdir/tmpGitRepo" || continue
  {
    echo "~~~~~~~~~~~~~~~~~~ $stringToSearch ~~~~~~~~~~~~~~~~~~"
    git grep -I -n -i -o -E "$stringToSearch" -- "$fileRegex" "$fileRegexExclude" "$fileRegexExclude2"
    echo "~~~~~~~~~~~~~~~~~~ $stringToSearch2 ~~~~~~~~~~~~~~~~~~"
    git grep -I -n -i -o -E -w "$stringToSearch2" -- "$fileRegex" "$fileRegexExclude" "$fileRegexExclude2"
  } >>"../$outputFile"

  if [ "$regNum" -eq 1 ]; then
    {
      echo "~~~~~~~~~~~~~~~~~~ $stringToSearch3 ~~~~~~~~~~~~~~~~~~"
      git grep -I -n -i -o -E -w "$stringToSearch3" -- "$fileRegex" "$fileRegexExclude" "$fileRegexExclude2"
      echo "~~~~~~~~~~~~~~~~~~ $stringToSearch4 ~~~~~~~~~~~~~~~~~~"
      git grep -I -n -i -o -E -w "$stringToSearch4" -- "$fileRegex" "$fileRegexExclude" "$fileRegexExclude2"
      echo "~~~~~~~~~~~~~~~~~~ $stringToSearch5 ~~~~~~~~~~~~~~~~~~"
      git grep -I -n -i -o -E -w "$stringToSearch5" -- "$fileRegex" "$fileRegexExclude" "$fileRegexExclude2"
      echo "~~~~~~~~~~~~~~~~~~ $stringToSearch6 ~~~~~~~~~~~~~~~~~~"
      git grep -I -n -i -o -E -w "$stringToSearch6" -- "$fileRegex" "$fileRegexExclude" "$fileRegexExclude2"
    } >>"../$outputFile"
  fi

  cd "$workdir" || exit 1
  rm -rf "$workdir/tmpGitRepo"
  ((counter++))

done <"$1"
