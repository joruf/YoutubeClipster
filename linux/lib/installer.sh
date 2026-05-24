#!/bin/bash

# Helper function to automatically install missing system packages
check_and_install() {
    local cmd="$1"
    local pkg="$2"
    
    if ! command -v "$cmd" &>/dev/null; then
        log_message "WARN" "Dependency '$cmd' is missing. Starting automatic installation via apt..."
        
        # Using sudo within terminal context for package management execution
        sudo apt update && sudo apt install -y "$pkg" || { 
            log_message "ERROR" "Installation of $pkg failed!"
            exit 1
        }
        log_message "INFO" "'$pkg' successfully installed."
    else
        log_message "DEBUG" "Dependency found: $cmd"
    fi
}

# Verify and setup all core runtime dependencies for YouTube Clipster
check_dependencies() {
    log_message "INFO" "Starting system dependency check..."
    
    # 1. Verify standard core utilities
    check_and_install "zenity" "zenity"
    check_and_install "ffmpeg" "ffmpeg"
    check_and_install "curl" "curl"
    
    # 2. Check and evaluate clipboard managers based on desktop session type (Wayland / X11)
    if ! command -v wl-paste &>/dev/null && ! command -v xclip &>/dev/null; then
        if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
            check_and_install "wl-paste" "wl-clipboard"
        else
            check_and_install "xclip" "xclip"
        fi
    fi
    
    # 3. Ensure a JavaScript runtime environment is available for native yt-dlp signature decryption
    if ! command -v node &>/dev/null && ! command -v deno &>/dev/null && ! command -v qjs &>/dev/null; then
        log_message "WARN" "No JavaScript runtime found for yt-dlp. Installing quickjs..."
        sudo apt update && sudo apt install -y quickjs || {
            log_message "ERROR" "quickjs installation failed! yt-dlp might encounter format extraction issues."
        }
    fi
    
    log_message "INFO" "All system dependencies are satisfied."
}
