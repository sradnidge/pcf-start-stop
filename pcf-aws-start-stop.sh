#!/bin/bash
# Updated for 1.6 with workaround for nfs_mounter
# Updated for 1.7 new Gemfile location
# Updated for 1.7.x no longer need to use bundle

# bosh cmd is an alias set in .profile
shopt -s expand_aliases
source ~/.profile

function usage {
  echo "Usage: ${0##*/} [stop | start]"
  exit 1
}

if [ $# -ne 1 ]
then
  usage
fi

# These must be explicitly stopped due to nfs_mounter blocking as of 1.6.17
declare -a bootOrder=(
  cloud_controller
  clock_global
  cloud_controller_worker
)

case $1 in

  'stop')
    jobVMs=$(bosh vms --detail| grep partition| awk -F '|' '{ print $2 }')
    bosh vm resurrection off
    for (( i = 0; i < ${#bootOrder[@]}; i++ )); do
      for x in $jobVMs; do
        jobId=$(echo $x | awk -F "/" '{ print $1 }')
        instanceId=$(echo $x | awk -F "/" '{ print $2 }')
        jobType=$(echo $jobId | awk -F "-" '{ print $1 }')
          if [ "$jobType" == "${bootOrder[$i]}" ];
          then
            echo "stopping $jobType ($jobId/$instanceId)"
            bosh -n stop $jobId --hard # the --hard option means delete VMs
          fi
      done;
    done;
    bosh -n stop --hard # the --hard option means delete VMs
    ;;

  'start')
    bosh -n start
    bosh vm resurrection on
    ;;

  *)
    usage
    ;;

esac
