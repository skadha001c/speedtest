#!/bin/bash

PREV_TOTAL=0
PREV_USAGE=0
secs=60
  #find the device model
  MODEL=$(cat /etc/device.properties |grep MODEL_NUM | cut -d'=' -f 2)
while [ $secs -gt 0 ]; do
  CPU=($(sed -n 's/^cpu\s//p' /proc/stat))
  IDLE=${CPU[3]}

  TOTAL=0
  for VALUE in "${CPU[@]:0:8}"; do
    TOTAL=$((TOTAL+VALUE))
  done
#echo $TOTAL $IDLE
CURRENT_USAGE=$((TOTAL-IDLE))
  # Calculate the CPU usage since we last checked.
  NUMERATOR=$((CURRENT_USAGE-PREV_USAGE))
  DIFF_TOTAL=$((TOTAL-PREV_TOTAL))
#echo $DIFF_IDLE $DIFF_TOTAL
DIFF_USAGE=$(((100*NUMERATOR)/DIFF_TOTAL))
#  DIFF_USAGE=$(((1000*(DIFF_TOTAL-DIFF_IDLE)/DIFF_TOTAL+5)/10))

#Caculate the memory usage
TEMP=$( cat /proc/meminfo | grep -o -E '[0-9]+')
ARR=($TEMP); set +f
MEM_TOTAL=${ARR[0]}
MEM_FREE=${ARR[1]}
BUFFERS=${ARR[3]}
CACHED=${ARR[4]}
ARG1=$(($MEM_FREE+$BUFFERS+$CACHED))*100
MEM_USAGE=$(awk "BEGIN {printf \"%.2f\",100-${ARG1}/${MEM_TOTAL}}")

#Print with timestamp
  timestamp=$(date +%Y%m%d-%H:%M:%S)
  echo $timestamp - CPU_Usage: "$DIFF_USAGE %" - Memory_Usage: "$MEM_USAGE%"

  # Remember the total and idle CPU times for the next check.
  PREV_TOTAL="$TOTAL"
  PREV_USAGE="$CURRENT_USAGE"

  # Wait before checking again.
  sleep 1
  : $((secs--))
done