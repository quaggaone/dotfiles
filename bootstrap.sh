#!/bin/zsh

# Check if Xcode command line tools are already installed
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode command line tools..."
    
    # Trigger the installation
    xcode-select --install

    # Wait for the installation to complete
    # This will loop until the installation is done
    while ! xcode-select -p &>/dev/null; do
        sleep 5
    done

    echo "Xcode command line tools installed successfully."
else
    echo "Xcode command line tools are already installed."
fi

# Clone this repo into ~/dotfiles/; skip if found
echo "Cloning repo to disk..."
# [ ! -d "$HOME/dotfiles" ] && git clone URL ~/dotfiles		

# Install Homebrew; skip if found
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew from Github..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# Install stow
echo "Installing stow via brew..."
brew install stow

# Stow dotfiles to home directory
cd ~/dotfiles
stow .

# Next steps
echo "Next Steps:"
echo "Configure System Settings using ~/dotfiles/defaults/system/index.sh"
echo "Install programms via brew using brew bundle install Brewfile"

