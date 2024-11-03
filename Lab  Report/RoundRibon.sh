#!/bin/bash

# Declare arrays to hold burst time, waiting time, and turnaround time
declare -a burst_time
declare -a waiting_time
declare -a turnaround_time

# Number of processes and time quantum
num_processes=0
time_quantum=0

# Function to calculate waiting time
calculate_waiting_time() {
    local remaining_time=("${burst_time[@]}")
    local total_time=0

    while true; do
        local done=true  # Reset `done` at the start of each loop

        for ((i=0; i<num_processes; i++)); do
            if [ ${remaining_time[i]} -gt 0 ]; then
                done=false  # Process is not done

                if [ ${remaining_time[i]} -le $time_quantum ]; then
                    total_time=$((total_time + remaining_time[i]))
                    waiting_time[i]=$((total_time - burst_time[i]))
                    remaining_time[i]=0
                else
                    total_time=$((total_time + time_quantum))
                    remaining_time[i]=$((remaining_time[i] - time_quantum))
                fi
            fi
        done

        if [ "$done" = true ]; then
            break
        fi
    done
}

# Function to calculate turnaround time
calculate_turnaround_time() {
    for ((i=0; i<num_processes; i++)); do
        turnaround_time[i]=$((burst_time[i] + waiting_time[i]))
    done
}

# Function to calculate average waiting time and turnaround time
calculate_average_times() {
    local total_waiting_time=0
    local total_turnaround_time=0

    calculate_waiting_time
    calculate_turnaround_time

    echo -e "PROCESS\tBURST TIME\tWAITING TIME\tTURNAROUND TIME"
    for ((i=0; i<num_processes; i++)); do
        total_waiting_time=$((total_waiting_time + waiting_time[i]))
        total_turnaround_time=$((total_turnaround_time + turnaround_time[i]))
        echo -e "$((i + 1))\t${burst_time[i]}\t\t${waiting_time[i]}\t\t${turnaround_time[i]}"
    done

    # Calculate integer-based average times with simulated floating point
    average_waiting_time=$(( (total_waiting_time * 100) / num_processes ))
    average_turnaround_time=$(( (total_turnaround_time * 100) / num_processes ))

    # Output averages with two decimal places
    echo "Average Waiting Time = $((average_waiting_time / 100)).$((average_waiting_time % 100))"
    echo "Average Turnaround Time = $((average_turnaround_time / 100)).$((average_turnaround_time % 100))"
}

# Main script starts here
echo "Enter the number of processes: "
read num_processes

for ((i=0; i<num_processes; i++)); do
    echo "Enter Burst Time for process $((i + 1)): "
    read burst_time[i]
done

echo "Enter the size of time quantum: "
read time_quantum

# Calculate and display average times
calculate_average_times
