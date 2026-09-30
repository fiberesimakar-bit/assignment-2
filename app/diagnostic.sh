#!/bin/bash

case "$1" in
    help)
        echo "Usage:"
        echo "  diagnostic system"
        echo "  diagnostic network <host>"
        echo "  diagnostic disk"
        echo "  diagnostic help"
        ;;

    system)
        echo "System Information"
        echo "=================="
        echo "Hostname: $(hostname)"
        echo "User: $(whoami)"
        echo "Operating System: $(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')"
        echo "Kernel: $(uname -r)"
        echo "Uptime: $(uptime -p)"
        echo "CPU: $(lscpu | grep 'Model name' | head -1 | cut -d: -f2- | xargs)"
        echo "Memory:"
        free -h
        ;;

    disk)
        echo "Disk Usage"
        echo "=========="
        df -h /
        ;;

            network)
        if [ -z "$2" ]; then
            echo "Error: Please provide a hostname or IP address."
            exit 2
        fi

        echo "Network Check"
        echo "============="
        echo "Host: $2"
                ip_address=$(getent hosts "$2" | awk '{print $1}' | head -1)
        echo "IP Address: ${ip_address:-Not resolved}"

        if ping -c 1 "$2" > /dev/null 2>&1; then
            echo "Status: Host is reachable"
        else
            echo "Status: Host is not reachable"
            exit 1
        fi
        ;;

            *)
        echo "Error: Unknown command."
        echo "Run './app/diagnostic.sh help' for usage."
        exit 2
        ;;

esac
