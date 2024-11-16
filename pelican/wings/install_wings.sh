#!/bin/bash

# Get the current kernel version
KERNEL_VERSION=$(uname -r)

# Check if the kernel version ends with the problematic suffixes
if [[ "$KERNEL_VERSION" == *-grs-ipv6-64 || "$KERNEL_VERSION" == *-mod-std-ipv6-64 ]]; then
    echo "WARNING: Your kernel version is '$KERNEL_VERSION'."
    echo "This is a modified kernel that does not support some Docker features required for Wings to operate correctly."
    echo "Please contact your host and request a non-modified kernel."
    exit 1
else
    echo "Your kernel version is '$KERNEL_VERSION'. It appears to be a supported kernel."
fi
