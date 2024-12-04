#!/bin/bash

# Function to run a command silently and display a custom success message
run_silent() {
    local task_name="$1"
    shift
    "$@" &> /dev/null  # Run the command silently (redirect output to /dev/null)
    if [ $? -eq 0 ]; then
        echo -e "[\e[32mOK\e[0m] $task_name completed."
    else
        echo -e "[\e[31mFAILED\e[0m] $task_name failed."
    fi
}

# Update package list
run_silent "Updating package list" sudo apt update

# Install QEMU guest agent
run_silent "Installing QEMU guest agent" sudo apt install -y qemu-guest-agent

# Enable QEMU guest agent service
run_silent "Enabling QEMU guest agent service" sudo systemctl enable qemu-guest-agent

# Start QEMU guest agent service
run_silent "Starting QEMU guest agent service" sudo systemctl start qemu-guest-agent

# Check QEMU guest agent service status
run_silent "Checking QEMU guest agent service status" sudo systemctl status qemu-guest-agent

# Install Avahi Daemon (mDNS support)
run_silent "Installing Avahi Daemon (mDNS)" sudo apt install -y avahi-daemon

# Enable Avahi Daemon
run_silent "Enabling mDNS (Avahi Daemon)" sudo systemctl enable avahi-daemon

# Start Avahi Daemon
run_silent "Starting mDNS (Avahi Daemon)" sudo systemctl start avahi-daemon
