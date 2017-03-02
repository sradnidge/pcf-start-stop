#!/bin/bash

# bosh cmd is an alias set in .profile of ops manager user
shopt -s expand_aliases
source ~/.profile

function usage {
  echo "Usage: ${0##*/} (start | stop) [--hard]"
  exit 1
}

# @param Array
# @param Element
# @returns 0 if element is in Array, 1 if not
# @example hasIn "${Array[@]}" "Element"
function hasIn {
  local e
  for e in "${1}"
  do
    [[ "$e" == "$2" ]] && return 0
  done
  return 1
}

if [ $# -eq 0 ]
then
  usage
fi

case $1 in

  'start')
    bosh -n start
    bosh vm resurrection on
    ;;

  'stop')
    bosh vm resurrection off

    # Get a friendly list of jobs
    jobVMs=$(bosh vms --detail | grep -E '^\|.[a-z]' | awk -F '|' '{ print $2 }' | tr -d '[[:blank:]]')

    # If doing a hard stop, do not delete these jobs (if they exist)
    declare -a doNotDelete=(
      mysql
      nfs_server
    )

    for x in $jobVMs
    do
      job=$(echo $x | awk -F "/" '{ print $1 }')
      index=$(echo $x | awk -F "/" '{ print $2 }' | awk -F "(" '{ print $1 }')
      jobId=$(echo $x | awk -F "(" '{ print $2 }' | awk -F ")" '{ print $1 }')
      if [ -n "$2" ] && [ "$2" == "--hard" ]
      then
        # hard stop everything except jobs in doNotDelete
        if hasIn "${doNotDelete[@]}" "$job"
        then
          echo "stopping $job/$index (job id:$jobId)"
          bosh -n stop $job $index --force
        else
          echo "deleting $job/$index (job id:$jobId)"
          bosh -n stop $job $index --hard --force
        fi
      else
        echo "stopping $job/$index (job id:$jobId)"
        bosh -n stop $job $index
      fi
    done;
    ;;

  *)
    usage
    ;;

esac
