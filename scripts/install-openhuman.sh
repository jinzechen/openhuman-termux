#!/bin/bash
set -e
GREEN='\033[0;32m'
YELLOW='\033[1;3m'
BLUE='\033[0;34m'
NC='\033[0m'
echo -e "${BLUE}[1/4]${NC} Installing Termux packages..."
pkg update -y
pkg install -y nodejs-lts git proot-distro
echo -e "${BLUE}[2/4]${NC} Installing Ubuntu..."
proot-distro install ubuntu 2>/dev/null || echo "Ubuntu already installed"
echo -e "${BLUE}[3/4]${NC} Installing Rust + Node.js in Ubuntu..."
proot-distro login ubuntu -- bash -c '
    apt update && apt upgrade -y
    apt install -y curl git build-essential cmake pkg-config libssl-dev python3 unzip wget
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt install -y nodejs
    npm install -g pnpm
'
echo -e "${BLUE}[4/4]${NC} Cloning OpenHuman..."
proot-distro login ubuntu -- bash -c '
    source "$HOME/.cargo/env"
    cd /opt
    git clone https://github.com/tinyhumansai/openhuman.git
    cd openhuman
    pnpm install
'
echo -e "${GREEN}Setup complete!${NC}"

