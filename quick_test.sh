#!/bin/bash
# Quick test script for InlineCoder

echo "🔍 InlineCoder Quick Test"
echo "=========================="
echo ""

# Check Neovim
echo -n "✓ Neovim installed: "
if command -v nvim &> /dev/null; then
    nvim --version | head -n1
else
    echo "❌ NOT FOUND - Install Neovim first"
    exit 1
fi

echo ""

# Check if plugin is symlinked
echo -n "✓ Plugin symlinked: "
if [ -d "$HOME/.local/share/nvim/site/pack/plugins/start/inlinecoder" ]; then
    echo "YES ✅"
else
    echo "NO ❌"
    echo "  Run: ln -s $(pwd) ~/.local/share/nvim/site/pack/plugins/start/inlinecoder"
    exit 1
fi

echo ""

# Check plenary
echo -n "✓ plenary.nvim: "
if [ -d "$HOME/.local/share/nvim/site/pack/plugins/start/plenary.nvim" ]; then
    echo "YES ✅"
else
    echo "NO ❌"
    echo "  Install: git clone https://github.com/nvim-lua/plenary.nvim ~/.local/share/nvim/site/pack/plugins/start/plenary.nvim"
    exit 1
fi

echo ""

# Check LM Studio
echo -n "✓ LM Studio API: "
if curl -s -f http://localhost:4040/v1/models > /dev/null 2>&1; then
    echo "RUNNING ✅ (port 4040)"
else
    echo "NOT RUNNING ❌"
    echo "  Check if LM Studio server is running on port 4040"
    echo "  Or update this script if using a different port"
    exit 1
fi

echo ""
echo "================================"
echo "✅ All checks passed!"
echo ""
echo "Next steps:"
echo "1. Open Neovim: nvim test_example.py"
echo "2. Select a function with 'V' (visual line mode)"
echo "3. Run: :InlineCoderGenerate"
echo "4. Enter prompt: 'add error handling'"
echo "5. Watch the magic happen! ✨"
