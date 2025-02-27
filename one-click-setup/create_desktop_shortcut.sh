#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create desktop shortcut for Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cat > ~/Desktop/BSV-Networks.desktop << EOF2
[Desktop Entry]
Type=Application
Name=BSV Networks
Comment=Start Bitcoin SV Networks
Exec=bash -c "cd ${SCRIPT_DIR} && ./start.sh; bash"
Icon=terminal
Terminal=true
Categories=Development;
EOF2
    chmod +x ~/Desktop/BSV-Networks.desktop
    echo "Desktop shortcut created at ~/Desktop/BSV-Networks.desktop"

# Create desktop shortcut for macOS
elif [[ "$OSTYPE" == "darwin"* ]]; then
    cat > ~/Desktop/BSV-Networks.command << EOF2
#!/bin/bash
cd "${SCRIPT_DIR}"
./start.sh
EOF2
    chmod +x ~/Desktop/BSV-Networks.command
    echo "Desktop shortcut created at ~/Desktop/BSV-Networks.command"

# Create desktop shortcut for Windows (if running in WSL)
elif [[ -n "$WSL_DISTRO_NAME" ]]; then
    cat > /mnt/c/Users/Public/Desktop/BSV-Networks.bat << EOF2
@echo off
wsl -d ${WSL_DISTRO_NAME} -e bash -c "cd ${SCRIPT_DIR} && ./start.sh && bash"
EOF2
    echo "Desktop shortcut created at C:\\Users\\Public\\Desktop\\BSV-Networks.bat"

# Unknown OS
else
    echo "Unsupported operating system: $OSTYPE"
    echo "Please create a desktop shortcut manually to run the start.sh script."
fi
