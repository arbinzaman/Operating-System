#!/bin/bash 

echo "Enter number of processes:"

read n

declare -a burstTimes
declare -a waitingTimes
declare -a turnaroundTimes

for (( i=0; i<n; i++ )); do
	echo "Enter burst time for process $((i+1)):"
	read burstTimes[$i]
done

waitingTimes[0]=0 

for (( i=1; i<n; i++ )); do
	waitingTimes[$i]=$((waitingTimes[i-1] + burstTimes[i-1]))
	turnaroundTimes[$i]=$((waitingTimes[i] + burstTimes[i]))
done

turnaroundTimes[0]=${burstTimes[0]}

echo -e "Process ID\tBurst Time\tWaiting Time\tTurnaround Time"

for (( i=0; i<n; i++ )); do
	echo -e "$((i+1))\t\t${burstTimes[i]}\t\t${waitingTimes[i]}\t\t${turnaroundTimes[i]}"
done
  
