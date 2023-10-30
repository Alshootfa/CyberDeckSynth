#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

if [[ $(uname) == "Darwin" ]]; then
    echo "Running macOS setup script..."
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is already installed."
    else
        echo "Homebrew is not installed."
        # ask user for confirmation
        read -p "Would you like to install Homebrew? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
                echo "Error: Failed to install Homebrew."
                exit 1
            }
        fi        
    fi
elif [[ $(uname) == "Linux" ]]; then
    echo "Running Linux setup script..."
    if command -v apt-get >/dev/null 2>&1; then
        echo "apt-get is already installed."
        # Install ZSH
        sudo apt-get update
        sudo apt-get install -y zsh
    else
        echo "apt-get is not installed."
    fi
else
    echo "Unsupported operating system."
    exit 1
fi

# Set ZSH as Default Shell
chsh -s $(which zsh)

# Install Oh My Zsh
if [ -d ~/.oh-my-zsh ]; then
    echo "Oh My Zsh is already installed."
else
    echo "Oh My Zsh is not installed."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
        echo "Error: Failed to install Oh My Zsh."
        exit 1
    }
fi

# Install Starship
# check if starship is already installed
if command -v starship >/dev/null 2>&1; then
    echo "Starship is already installed."
else
    echo "Starship is not installed."
    # ask user for confirmation
    read -p "Would you like to install Starship? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing Starship..."
        if command -v curl >/dev/null 2>&1; then
            sh -c "$(curl -fsSL https://starship.rs/install.sh)" || {
                echo "Error: Failed to install Starship."
                exit 1
            }
            # Add Starship init script to .zshrc
            echo 'eval "$(starship init zsh)"' >> ~/.zshrc
        else
            echo "Error: curl is not installed."
            exit 1
        fi
    fi
fi

# Print completion message
echo "Installation complete! Restart your terminal or SSH session to see the changes."