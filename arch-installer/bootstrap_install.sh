#!/bin/sh

# Check if fish is installed
if ! command -v fish >/dev/null 2>&1; then
    echo "fish not found, installing..."
    # Fish complains about missing pcre2 for some reason. This doesn't seem to happen for actually
    # installed systems, just on the live iso
    pacman -Sy --noconfirm fish pcre2
else
    echo "fish is already installed"
fi

fish install.fish
