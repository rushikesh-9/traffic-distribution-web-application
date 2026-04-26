#!/bin/bash
##############################################
# firewall-setup.sh
# Firewalld rules for all 4 servers
# Author: Rushikesh Chandanwar
# Run as root on each server
##############################################

SERVER_ROLE=$1   # Pass: "haproxy" | "appserver" | "database"

if [ -z "$SERVER_ROLE" ]; then
  echo "Usage: $0 <haproxy|appserver|database>"
  exit 1
fi

echo "[*] Starting firewall configuration for: $SERVER_ROLE"

# Make sure firewalld is running
systemctl enable firewalld
systemctl start firewalld

# Set default zone to drop (deny everything by default)
firewall-cmd --set-default-zone=drop

echo "[*] Applying rules for: $SERVER_ROLE"

if [ "$SERVER_ROLE" == "haproxy" ]; then
  # HAProxy Load Balancer
  # Allow: SSH, HTTP (port 80), HAProxy Stats (port 8404)
  firewall-cmd --permanent --zone=drop --add-service=ssh
  firewall-cmd --permanent --zone=drop --add-service=http
  firewall-cmd --permanent --zone=drop --add-port=8404/tcp
  echo "[+] HAProxy rules applied: SSH, HTTP (80), Stats (8404)"

elif [ "$SERVER_ROLE" == "appserver" ]; then
  # Node.js Application Servers (App1 and App2)
  # Allow: SSH, app port 3001 (only from HAProxy IP range)
  firewall-cmd --permanent --zone=drop --add-service=ssh
  firewall-cmd --permanent --zone=drop --add-port=3001/tcp
  echo "[+] App server rules applied: SSH, Node.js (3001)"

elif [ "$SERVER_ROLE" == "database" ]; then
  # MySQL Database Server
  # Allow: SSH, MySQL port (only from app servers)
  firewall-cmd --permanent --zone=drop --add-service=ssh
  firewall-cmd --permanent --zone=drop --add-service=mysql
  echo "[+] Database rules applied: SSH, MySQL (3306)"
fi

# Apply changes
firewall-cmd --reload

echo "[*] Firewall rules loaded. Current configuration:"
firewall-cmd --list-all
