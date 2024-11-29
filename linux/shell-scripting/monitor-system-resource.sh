#!/bin/bash

# Monitoring the System Resources for Proxy Server.

set -x
set -e

usage() {
  echo "Usage: $0 [--cpu|--memory|--network|--disk|--load|--process|--services|--all] [--interval SECONDS]"
  echo "  --cpu       : Display CPU usage"
  echo "  --memory    : Display memory usage"
  echo "  --network   : Display network usage"
  echo "  --disk      : Display disk usage"
  echo "  --load      : Display system load"
  echo "  --process   : Display running processes"
  echo "  --services  : Display system services"
  echo "  --all       : Display all of the above"
  echo "  --interval  : Set refresh interval in seconds (default: 10)"
  exit 1
}

# Display top 10 most used applications
display_top_apps() {
  echo "Top 10 Applications by CPU Usage:"
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 11
  echo "Top 10 Applications by Memory Usage:"
  ps -eo pid,comm,%mem --sort=-%mem | head -n 11
}

# Display network Usage
display_network() {
  echo "Network Monitoring:"
  echo "Number of Concurrent Connections:"
  netstat -an | grep ESTABLISHED | wc -l
  echo "Packet Drops:"
  netstat -s | grep 'packet loss'
  echo "Network Traffic (MB In/Out):"
  ifstat 1 1
}

# Display disk usage
display_disk() {
  echo "Disk Usage:"
  df -h
  echo "Partitions using more than 80%:"
  df -h | awk '$5 > 80 {print $0}'
}

# Display system load
display_load() {
  echo "System Load Average:"
  uptime
  echo "CPU Usage Breakdown:"
  top -bn1 | grep "Cpu(s)"
}

# Display memory usage
display_memory() {
  echo "Memory Usage:"
  free -h
  echo "Swap Memory Usage:"
  swapon --show
}

# Display running processes
display_process() {
  echo "Number of Active Processes:"
  ps -e | wc -l
  echo "Top 5 Processes by CPU Usage:"
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
  echo "Top 5 Processes by Memory Usage:"
  ps -eo pid,comm,%mem --sort=-%mem | head -n 6
}

# Display system services
display_services() {
  echo "Service Status:"
  systemctl list-units --type=service --state=running
}

# Display all information
display_all() {
  display_top_apps
  echo
  display_network
  echo
  display_disk
  echo
  display_load
  echo
  display_memory
  echo
  display_process
  echo
  display_services
}

# Main script logic to parse command-line arguments
interval=10  # Default interval in seconds

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cpu) section="cpu" ;;
    --memory) section="memory" ;;
    --network) section="network" ;;
    --disk) section="disk" ;;
    --load) section="load" ;;
    --process) section="process" ;;
    --services) section="services" ;;
    --all) section="all" ;;
    --interval) shift; interval=$1 ;;
    *) usage ;;
  esac
  shift
done

# Check if a section was provided
if [[ -z "$section" ]]; then
  usage
fi

# Main loop for real-time updates
while true; do
  clear
  case "$section" in
    cpu) display_top_apps ;;
    memory) display_memory ;;
    network) display_network ;;
    disk) display_disk ;;
    load) display_load ;;
    process) display_process ;;
    services) display_services ;;
    all) display_all ;;
  esac
  sleep "$interval"
done
