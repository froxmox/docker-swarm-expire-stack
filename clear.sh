#!/bin/bash
set -e
today=$(date -d $(date +%Y-%m-%d) '+%s')
list=($(docker stack ls | grep -v 'NAME\|master' | awk '{print $1}'))
for stack in ${list[@]}; do
cont=($(docker stack ps "$stack" | grep "Running" | awk '{print $1}' | grep '\S'))
cont_created=($(docker inspect $cont --format "{{.UpdatedAt}}" | awk '{print $1}'))
del=true
   for i in ${cont_created[@]}; do
     days=($(( ($today - $(date -d $i +%s)) / (60*60*24) )))
     if [[ ${days} < 5 ]]; then
       del=false
     else echo "docker stack rm $stack"
     fi
   done
done
