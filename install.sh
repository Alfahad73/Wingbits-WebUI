#!/bin/bash

# ==========================================
# Wingbits Station Web Config - Installer
# ==========================================

set -e

REPO_URL="https://github.com/Alfahad73/Wingbits-WebUI.git"
INSTALL_DIR="/opt/wingbits-webui"

# إذا كنت داخل مجلد المشروع، نفذ التثبيت مباشرة
if [ -f "$(dirname "$0")/project-setup.sh" ]; then
    SCRIPT_DIR="$(dirname "$(realpath "$0")")"
else
    # إذا لم تكن الملفات موجودة، نزّل الريبو كامل
    if [ ! -d "$INSTALL_DIR" ]; then
        echo "Cloning Wingbits-WebUI project to $INSTALL_DIR ..."
        git clone "$REPO_URL" "$INSTALL_DIR"
    else
        echo "Project directory already exists at $INSTALL_DIR"
    fi
    cd "$INSTALL_DIR"
    exec bash install.sh "$@"
    exit 0
fi

echo ""
echo "======================================"
echo "      Wingbits Station Web Config"
echo "      Web Control Panel Installation Script"
echo "======================================"
echo ""
echo "This script will install all requirements, create the necessary files,"
echo "setup the web backend/frontend, and start the service automatically."
echo ""

# --- Check for root privileges ---
if [ "$EUID" -ne 0 ]; then
    echo "? Please run as root (sudo bash $0)"
    exit 1
fi

# --- 1. Check if Wingbits client is installed ---
if ! command -v wingbits &> /dev/null; then
    echo "------------------------------------------------------------"
    echo "?? Wingbits client is not installed."
    echo ""
    if [[ -n "$loc" && -n "$id" ]]; then
        LAT="$(echo $loc | cut -d',' -f1 | xargs)"
        LON="$(echo $loc | cut -d',' -f2 | xargs)"
        STATION_ID="$id"
        echo "Detected location from environment: $LAT, $LON"
        echo "Detected station ID from environment: $STATION_ID"
    else
        read -p "Please enter your Latitude: " LAT
        read -p "Please enter your Longitude: " LON
        read -p "Please enter your Station ID: " STATION_ID
    fi

    # Validate inputs
    if [ -z "$LAT" ] || [ -z "$LON" ] || [ -z "$STATION_ID" ]; then
        echo "? Latitude, Longitude, and Station ID cannot be empty. Exiting."
        exit 1
    fi

    echo "Installing Wingbits client with the provided details..."

    curl -sL https://gitlab.com/wingbits/config/-/raw/master/download.sh | sudo loc="$LAT, $LON" id="$STATION_ID" bash

    echo "? Wingbits client installation finished."
else
    echo "? Wingbits client is already installed."
fi

echo ""
# --- 2. Check if wb-config is installed ---
if ! command -v wb-config &> /dev/null; then
    echo "wb-config is not installed, installing it now..."
    curl -sL https://gitlab.com/wingbits/config/-/raw/master/wb-config/install.sh | sudo bash
else
    echo "? wb-config is already installed."
fi

echo ""
# --- Make all sub-scripts executable ---
echo "Setting execute permissions for sub-scripts..."
chmod +x "$SCRIPT_DIR/dependencies.sh"
chmod +x "$SCRIPT_DIR/project-setup.sh"
chmod +x "$SCRIPT_DIR/backend-deps.sh"
chmod +x "$SCRIPT_DIR/backend-app.sh"
chmod +x "$SCRIPT_DIR/frontend-html.sh"
chmod +x "$SCRIPT_DIR/systemd-service.sh"
chmod +x "$SCRIPT_DIR/final-message.sh"
echo "Execute permissions set."
echo ""

# --- 3. Run individual setup scripts sequentially ---
echo "Starting installation of BYOD Web Config Panel..."

"$SCRIPT_DIR/dependencies.sh"
"$SCRIPT_DIR/project-setup.sh"
"$SCRIPT_DIR/backend-deps.sh"
"$SCRIPT_DIR/backend-app.sh"
"$SCRIPT_DIR/frontend-html.sh"
"$SCRIPT_DIR/systemd-service.sh"
"$SCRIPT_DIR/final-message.sh"

exit 0
