#!/bin/bash
##############################################
# start-services.sh
# Starts all required services on each server
# Author: Rushikesh Chandanwar
##############################################

SERVER_ROLE=$1   # Pass: "haproxy" | "appserver" | "database"

if [ -z "$SERVER_ROLE" ]; then
  echo "Usage: $0 <haproxy|appserver|database>"
  exit 1
fi

if [ "$SERVER_ROLE" == "haproxy" ]; then
  echo "[*] Starting HAProxy..."
  systemctl enable haproxy
  systemctl start haproxy
  systemctl status haproxy
  echo "[+] HAProxy is running. Stats at http://<haproxy-ip>:8404/stats"

elif [ "$SERVER_ROLE" == "appserver" ]; then
  echo "[*] Starting Node.js app via systemd..."
  systemctl enable bus-booking-app
  systemctl start bus-booking-app
  systemctl status bus-booking-app
  echo "[+] Node.js app is running on port 3001"

elif [ "$SERVER_ROLE" == "database" ]; then
  echo "[*] Starting MySQL..."
  systemctl enable mysqld
  systemctl start mysqld
  systemctl status mysqld
  echo "[+] MySQL is running on port 3306"
fi
