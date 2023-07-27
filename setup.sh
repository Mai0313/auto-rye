#!/bin/bash

# 定義顏色
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 檢查rustup是否有安裝
if ! command -v rustup >/dev/null 2>&1; then
    echo -e "
            ${RED}rustup could not be found${NC}

            ${YELLOW}Installing rustup...${NC}
            "
    curl -sSf https://raw.githubusercontent.com/rust-lang/rustup/master/rustup-init.sh | sh -s -- -y || exit 1
else
    echo -e "
            ${GREEN}rustup is already installed${NC}"
fi

if command -v rustup >/dev/null 2>&1; then
    echo -e "
            ${GREEN}rustup has been installed${NC}
            "
else
    echo -e "
            ${RED}rustup could not be installed${NC}"
    exit 1
fi

# 檢查rye是否有安裝
if ! command -v rye >/dev/null 2>&1; then
    echo -e "
            ${RED}rye could not be found${NC}
    
            ${YELLOW}Installing rye...${NC}
            "

    cargo install --git https://github.com/mitsuhiko/rye rye || exit 1
    echo 'export PATH="$HOME/.rye/env"' >> ~/.bashrc
    source ~/.bashrc
    echo -e "
            ${GREEN}rye has been installed${NC}"
else
    echo -e "
            ${GREEN}rye is already installed${NC}"
fi

if command -v rye >/dev/null 2>&1; then
    echo -e "
            ${GREEN}rye has been installed${NC}
            "
else
    echo -e "
            ${RED}rye could not be installed${NC}"
    exit 1
fi

source ~/.bashrc

PYPROJECT_TOML="$(pwd)/pyproject.toml"
REQ_LOCK="$(pwd)/requirements.lock"
VENV_DIR="$(pwd)/.venv"

if [ ! -f $PYPROJECT_TOML ] && [ ! -f $REQ_LOCK ]; then
    echo -e "
        Missing: 

        ${RED}$PYPROJECT_TOML${NC}
        
        ${RED}$REQ_LOCK${NC}

        Try these commands below:

        ${YELLOW}git fetch${NC}

        ${YELLOW}git checkout master${NC}

        ${YELLOW}git pull origin master${NC}"
elif [ -f $PYPROJECT_TOML ] && [ ! -f $REQ_LOCK ]; then
    echo -e "
        Missing: 

        ${RED}$REQ_LOCK${NC}

        Try this command below:

        ${YELLOW}rye sync${NC}"
    rye sync
elif [ -f $PYPROJECT_TOML ] && [ -f $REQ_LOCK ] && [ ! -d $VENV_DIR ]; then
    echo -e "
        Missing: 

        ${RED}$VENV_DIR${NC}

        Try this command below:

        ${YELLOW}rye sync --no-lock${NC}
        "
    rye sync --no-lock

else
    read -p "Do you wanna force run rye? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "
            ${YELLOW}rye sync --no-lock${NC}"
        rye sync --no-lock
    else
        echo -e "
            ${GREEN}rye is already installed${NC}"
    fi

fi

# rm -rf /home/wei/.rustup && rm -rf /home/wei/.cargo && rm -rf /home/wei/.rye