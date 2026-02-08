#!/bin/bash
# InlineCoder Installation Script
# Installs inlinecoder to Neovim's plugin directory

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   InlineCoder Installation Script    ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""

# Detect Neovim config directory
if [ -d "$HOME/.config/nvim" ]; then
    NVIM_DIR="$HOME/.local/share/nvim/site/pack/plugins/start"
elif [ -d "$HOME/AppData/Local/nvim" ]; then
    # Windows
    NVIM_DIR="$HOME/AppData/Local/nvim-data/site/pack/plugins/start"
else
    echo -e "${YELLOW}Warning: Could not detect Neovim config directory${NC}"
    NVIM_DIR="$HOME/.local/share/nvim/site/pack/plugins/start"
fi

echo -e "${BLUE}Installation directory:${NC} $NVIM_DIR"
echo ""

# Create directory if it doesn't exist
if [ ! -d "$NVIM_DIR" ]; then
    echo -e "${YELLOW}Creating plugin directory...${NC}"
    mkdir -p "$NVIM_DIR"
fi

# Check if inlinecoder already exists
if [ -d "$NVIM_DIR/inlinecoder" ]; then
    echo -e "${YELLOW}Warning: inlinecoder already exists at $NVIM_DIR/inlinecoder${NC}"
    read -p "Remove existing installation? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$NVIM_DIR/inlinecoder"
        echo -e "${GREEN}✓ Removed existing installation${NC}"
    else
        echo -e "${RED}✗ Installation cancelled${NC}"
        exit 1
    fi
fi

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create symlink or copy files
read -p "Create symlink (recommended for development) or copy files? (s/c): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    # Symlink
    ln -s "$SCRIPT_DIR" "$NVIM_DIR/inlinecoder"
    echo -e "${GREEN}✓ Created symlink${NC}"
else
    # Copy
    cp -r "$SCRIPT_DIR" "$NVIM_DIR/inlinecoder"
    echo -e "${GREEN}✓ Copied files${NC}"
fi

# Check for plenary.nvim
echo ""
echo -e "${BLUE}Checking dependencies...${NC}"

PLENARY_DIR="$HOME/.local/share/nvim/site/pack/plugins/start/plenary.nvim"
if [ -d "$PLENARY_DIR" ]; then
    echo -e "${GREEN}✓ plenary.nvim found${NC}"
else
    echo -e "${YELLOW}⚠ plenary.nvim not found${NC}"
    read -p "Install plenary.nvim? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        cd "$NVIM_DIR"
        git clone https://github.com/nvim-lua/plenary.nvim
        echo -e "${GREEN}✓ plenary.nvim installed${NC}"
    fi
fi

# Installation complete
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Installation Complete! 🎉           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Start LM Studio and load a code model"
echo "2. Start the LM Studio local server (default: http://localhost:1234)"
echo "3. Open Neovim"
echo "4. Add to your config (optional):"
echo ""
echo "   require('inlinecoder').setup()"
echo ""
echo "5. Try it out:"
echo "   - Select some code in visual mode"
echo "   - Run :InlineCoderGenerate"
echo "   - Enter a prompt like 'add error handling'"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "   - README.md: Full documentation"
echo "   - QUICKSTART.md: 5-minute setup guide"
echo "   - EXAMPLES.md: Usage examples"
echo ""
echo -e "${GREEN}Happy coding with AI! 🚀${NC}"
