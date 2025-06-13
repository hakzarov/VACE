#!/usr/bin/env bash

# Monitor script for andrusha.sh
LOG_FILE="andrusha_monitor.log"

echo "Starting andrusha.sh monitoring at $(date)" | tee -a "$LOG_FILE"

# Function to get random wait time between 1 and 60 seconds
get_random_wait() {
    echo $((RANDOM % 60 + 1))
}

# Function to check if a process is running
is_process_running() {
    local pid=$1
    if ps -p "$pid" > /dev/null; then
        return 0  # Process is running
    else
        return 1  # Process is not running
    fi
}

# Function to start andrusha.sh in the background and get its PID
start_andrusha() {
    echo "Starting andrusha.sh at $(date)" | tee -a "$LOG_FILE"
    bash andrusha.sh > andrusha_output.log 2>&1 &
    echo $!  # Return the PID
}

# Function to debug and attempt to fix errors
debug_and_fix() {
    echo "Error detected at $(date). Attempting to diagnose..." | tee -a "$LOG_FILE"
    
    # Check the latest error in the log file
    tail -n 20 andrusha_output.log | tee -a "$LOG_FILE"
    
    # Check if assets/prompts/used directory exists, create if not
    if [ ! -d "assets/prompts/used" ]; then
        echo "Creating missing directory: assets/prompts/used" | tee -a "$LOG_FILE"
        mkdir -p "assets/prompts/used"
    fi
    
    # Additional debugging logic can be added here
    
    echo "Debug complete. Restarting andrusha.sh..." | tee -a "$LOG_FILE"
}

# Main monitoring loop
while true; do
    # Start andrusha.sh in background if not already running
    if [ -z "$ANDRUSHA_PID" ] || ! is_process_running "$ANDRUSHA_PID"; then
        # If we had a previous PID and it's not running, there might have been an error
        if [ ! -z "$ANDRUSHA_PID" ]; then
            echo "andrusha.sh process (PID: $ANDRUSHA_PID) is no longer running at $(date)" | tee -a "$LOG_FILE"
            debug_and_fix
        fi
        
        # Start andrusha.sh and get its PID
        ANDRUSHA_PID=$(start_andrusha)
        echo "andrusha.sh started with PID: $ANDRUSHA_PID" | tee -a "$LOG_FILE"
    else
        echo "andrusha.sh (PID: $ANDRUSHA_PID) is running at $(date)" | tee -a "$LOG_FILE"
    fi
    
    # Get random wait time between 1 and 60 seconds
    WAIT_TIME=$(get_random_wait)
    echo "Waiting $WAIT_TIME seconds before next check..." | tee -a "$LOG_FILE"
    
    # Wait for the random time
    sleep "$WAIT_TIME"
done
