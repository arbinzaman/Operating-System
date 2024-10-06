#!/bin/bash

# Function to calculate the unique ID based on the student ID
calculate_unique_id() {
    local studentID="$1"
    local uniqueID=0
    for (( i=0; i<${#studentID}; i++ )); do
        uniqueID=$(( uniqueID + $(printf "%d" "'${studentID:i:1}") )) # ASCII value of characters
    done
    echo "$uniqueID"
}

# Function to gather process information and calculate waiting and turnaround times
process_scheduling() {
    local numProcesses=$1
    local arrivalTimes=()
    local burstTimes=()
    local waitingTimes=()
    local turnaroundTimes=()

    # Input arrival and burst times
    for (( i=0; i<numProcesses; i++ )); do
        read -p "Enter arrival time for Process $((i + 1)): " arrivalTime
        arrivalTimes+=("$arrivalTime")
        read -p "Enter burst time for Process $((i + 1)): " burstTime
        burstTimes+=("$burstTime")
        waitingTimes+=(0)
    done

    # Calculate waiting times
    for (( i=1; i<numProcesses; i++ )); do
        waitingTimes[$i]=$(( ${waitingTimes[$((i - 1))]} + ${burstTimes[$((i - 1))]} ))
        if (( ${arrivalTimes[$i]} > ${waitingTimes[$i]} )); then
            waitingTimes[$i]=0
        else
            waitingTimes[$i]=$(( ${waitingTimes[$i]} - ${arrivalTimes[$i]} ))
        fi
    done

    # Calculate turnaround times
    for (( i=0; i<numProcesses; i++ )); do
        turnaroundTimes[$i]=$(( ${waitingTimes[$i]} + ${burstTimes[$i]} ))
    done

    # Display the results
    echo -e "\nProcess\tArrival\tBurst\tWaiting\tTurnaround"
    for (( i=0; i<numProcesses; i++ )); do
        echo -e "P$((i + 1))\t${arrivalTimes[$i]}\t${burstTimes[$i]}\t${waitingTimes[$i]}\t${turnaroundTimes[$i]}"
    done

    # Calculate average waiting and turnaround times
    local totalWaitTime=0
    local totalTurnaroundTime=0
    for (( i=0; i<numProcesses; i++ )); do
        totalWaitTime=$((totalWaitTime + ${waitingTimes[$i]}))
        totalTurnaroundTime=$((totalTurnaroundTime + ${turnaroundTimes[$i]}))
    done

    # If you want to avoid using bc, consider using integer division for simplicity
    avgWaitTime=$(( totalWaitTime / numProcesses ))
    avgTurnaroundTime=$(( totalTurnaroundTime / numProcesses ))

    echo "Average Waiting Time: $avgWaitTime"
    echo "Average Turnaround Time: $avgTurnaroundTime"
}

# Main function
studentID="2125051016"
uniqueID=$(calculate_unique_id "$studentID")
echo "Unique ID based on Student ID ($studentID): $uniqueID"

read -p "Enter the number of processes: " processCount
process_scheduling "$processCount"
