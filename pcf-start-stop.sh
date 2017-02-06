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
# @usage hasIn "${Array[@]}" "Element"
function hasIn {
  local e
  for e in "${@:1}"
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
    jobVMs=$(bosh vms --detail| grep partition| awk -F '|' '{ print $2 }')

    # If doing a hard stop, do not delete these jobs (if they exist)
    declare -a doNotDelete=(
      mysql
      nfs_server
    )

    for x in $jobVMs
    do
      jobId=$(echo $x | awk -F "/" '{ print $1 }')
      instanceId=$(echo $x | awk -F "/" '{ print $2 }')
      jobType=$(echo $jobId | awk -F "-" '{ print $1 }')
      if [ -n "$2" ] && [ "$2" == "--hard" ]
      then
        # hard stop everything except jobs in doNotDelete
        if [ hasIn "${doNotDelete[@]}" "$jobType" ]
        then
          echo "stopping $jobType ($jobId/$instanceId)"
          bosh -n stop $jobId
        else
          echo "deleting $jobType ($jobId/$instanceId)"
          bosh -n stop $jobId --hard
        fi
      else
        echo "stopping $jobType ($jobId/$instanceId)"
        bosh -n stop $jobId
      fi
    done;
    ;;

  *)
    usage
    ;;

esac
