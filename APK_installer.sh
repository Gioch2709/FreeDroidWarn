#!/bin/bash

# Check if ADB is installed
if ! command -v adb &> /dev/null; then
    echo "Error: ADB is not installed. Install it with: sudo apt install adb"
    exit 1
fi

# Check for connected devices
echo "Checking for Android devices..."
device_status=$(adb devices | grep -v "List" | grep "device")

if [ -z "$device_status" ]; then
    echo "Error: No device found or unauthorized. Check USB Debugging."
    exit 1
fi

# Get list of APKs in current directory
apks=(*.apk)

if [ "${#apks[@]}" -eq 0 ] || [ ! -e "${apks[0]}" ]; then
    echo "No APK files found in this folder."
    exit 1
fi

echo "Available APKs:"
for i in "${!apks[@]}"; do
    echo "$((i+1)). ${apks[$i]}"
done
echo "0. Exit"

read -p "Select (0-${#apks[@]}): " choice

if [[ "$choice" == "0" ]]; then
    exit 0
elif [[ "$choice" -gt 0 && "$choice" -le "${#apks[@]}" ]]; then
    selected_apk="${apks[$((choice-1))]}"
    echo "Installing $selected_apk..."
    adb install "$selected_apk"
else
    echo "Invalid selection."
fi
