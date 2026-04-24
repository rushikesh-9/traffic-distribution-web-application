#!/bin/bash
##############################################
# install-dependencies.sh
# Installs Node.js, NPM, SQLite on app servers
# Author: Rushikesh Chandanwar
# Run as root on App Server 1 and App Server 2
##############################################

echo "[*] Updating system packages..."
dnf update -y

echo "[*] Installing Node.js and NPM..."
dnf install -y nodejs npm

echo "[*] Verifying Node.js installation..."
node -v
npm -v

echo "[*] Installing SQLite..."
dnf install -y sqlite sqlite-devel

echo "[*] Verifying SQLite installation..."
sqlite3 --version

echo "[*] Copying app files to /opt/bus-booking-app ..."
mkdir -p /opt/bus-booking-app
cp -r /path/to/app/* /opt/bus-booking-app/

echo "[*] Installing Node.js dependencies..."
cd /opt/bus-booking-app
npm install

echo "[+] All dependencies installed successfully."
echo "[*] To start the app: node server.js"
