#!/bin/bash

# Generate unique ID based on student ID
generateUniqueID() {
    local studentID=$1
    local uniqueCode=0

    # Calculate the unique code by summing up numeric characters only
    for ((i=0; i<${#studentID}; i++)); do
        char="${studentID:$i:1}"
        if [[ "$char" =~ [0-9] ]]; then
            uniqueCode=$((uniqueCode + char))
        fi
    done                                     

    echo "Unique ID based on studentID ($studentID): $uniqueCode"
}

# Replace with actual student ID
studentID="2125051006"

# Call the function with the student ID
generateUniqueID "$studentID"
