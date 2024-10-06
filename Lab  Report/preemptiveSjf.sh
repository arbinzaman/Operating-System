#!/bin/bash 

studentID="2125051006" 
uniqueCode=0 

# Function to calculate a unique ID based on the student ID
for (( i=0; i<${#studentID}; i++ )); do 
    uniqueCode=$(( uniqueCode + $(printf "%d" "'${studentID:$i:1}") )) 
done 

echo "Unique ID based on Student ID (${studentID}): $uniqueCode" 

preemptive_sjf() { 
    local n=$1 
    local -a arrival=("${!2}") 
    local -a burst=("${!3}") 
    local -a remaining_burst=("${burst[@]}") 
    local -a waiting_time 
    local -a turnaround_time 
    local time=0 
    local completed=0 
    local shortest=-1 
    local min_remaining_time=9999 
    local total_waiting_time=0 
    local total_turnaround_time=0 
    local end_time 

    while [ $completed -ne $n ]; do 
        for (( i = 0; i < n; i++ )); do 
            if [[ ${arrival[$i]} -le $time && ${remaining_burst[$i]} -lt $min_remaining_time && ${remaining_burst[$i]} -gt 0 ]]; then 
                min_remaining_time=${remaining_burst[$i]} 
                shortest=$i 
            fi 
        done 

        if [ $shortest -eq -1 ]; then 
            ((time++)) 
            continue 
        fi 

        ((remaining_burst[$shortest]--)) 
        ((time++)) 
        min_remaining_time=${remaining_burst[$shortest]} 

        if [ ${remaining_burst[$shortest]} -eq 0 ]; then 
            min_remaining_time=9999 
            ((completed++)) 
            end_time=$time 

            waiting_time[$shortest]=$((end_time - ${arrival[$shortest]} - ${burst[$shortest]})) 
            if [ ${waiting_time[$shortest]} -lt 0 ]; then 
                waiting_time[$shortest]=0 
            fi 

            turnaround_time[$shortest]=$((waiting_time[$shortest] + ${burst[$shortest]})) 

            total_waiting_time=$((total_waiting_time + waiting_time[$shortest])) 
            total_turnaround_time=$((total_turnaround_time + turnaround_time[$shortest])) 
        fi 
    done 

    echo -e "\nProcess\tArrival\tBurst\tWaiting\tTurnaround" 
    for (( i = 0; i < n; i++ )); do 
        echo -e "P$((i + 1))\t${arrival[$i]}\t${burst[$i]}\t${waiting_time[$i]:-0}\t${turnaround_time[$i]:-0}" 
    done 

    # Calculate averages without bc (integer division)
    local avg_waiting_time=$((total_waiting_time / n)) 
    local avg_turnaround_time=$((total_turnaround_time / n)) 

    echo "Average Waiting Time: $avg_waiting_time" 
    echo "Average Turnaround Time: $avg_turnaround_time" 
} 

echo "Enter the number of processes: " 
read n 
declare -a arrival 
declare -a burst 

for (( i = 0; i < n; i++ )); do 
    echo "Enter arrival time for process $((i + 1)):" 
    read arrival[$i] 
    echo "Enter burst time for process $((i + 1)):" 
    read burst[$i] 
done 

preemptive_sjf $n arrival[@] burst[@]
