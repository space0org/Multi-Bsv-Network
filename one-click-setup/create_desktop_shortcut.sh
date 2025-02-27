#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESKTOP_DIR="$HOME/Desktop"

# Create desktop directory if it doesn't exist
mkdir -p "$DESKTOP_DIR"

# Create desktop shortcut for start.sh
cat > "$DESKTOP_DIR/Start_BSV_Networks.desktop" << EOL
[Desktop Entry]
Type=Application
Name=Start BSV Networks
Comment=Start JpyNetwork and LariNetwork
Exec=bash -c "cd $SCRIPT_DIR && ./start.sh; read -p 'Press Enter to close...'"
Icon=utilities-terminal
Terminal=true
Categories=Development;
EOL

# Create desktop shortcut for status.sh
cat > "$DESKTOP_DIR/BSV_Networks_Status.desktop" << EOL
[Desktop Entry]
Type=Application
Name=BSV Networks Status
Comment=Check status of JpyNetwork and LariNetwork
Exec=bash -c "cd $SCRIPT_DIR && ./status.sh; read -p 'Press Enter to close...'"
Icon=utilities-terminal
Terminal=true
Categories=Development;
EOL

# Create desktop shortcut for stop.sh
cat > "$DESKTOP_DIR/Stop_BSV_Networks.desktop" << EOL
[Desktop Entry]
Type=Application
Name=Stop BSV Networks
Comment=Stop JpyNetwork and LariNetwork
Exec=bash -c "cd $SCRIPT_DIR && ./stop.sh; read -p 'Press Enter to close...'"
Icon=utilities-terminal
Terminal=true
Categories=Development;
EOL

# Make shortcuts executable
chmod +x "$DESKTOP_DIR/Start_BSV_Networks.desktop"
chmod +x "$DESKTOP_DIR/BSV_Networks_Status.desktop"
chmod +x "$DESKTOP_DIR/Stop_BSV_Networks.desktop"

echo "Desktop shortcuts created successfully!"
