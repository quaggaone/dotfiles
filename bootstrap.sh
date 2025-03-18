#!/bin/zsh

# Check if Xcode command line tools are already installed
echo "Checking for Xcode command line tools..."
if ! xcode-select -p &>/dev/null; then
    echo "Not found..."
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

# Clone this repo into ~/dotfiles/; exit if found
echo "Cloning repo to disk..."
# Check if the directory exists
if [ -d "$HOME/dotfiles" ]; then
    echo "Directory $HOME/dotfiles already exists. Aborting..."
    exit 1
else
    git clone https://github.com/quaggaone/dotfiles.git ~/dotfiles
fi
cd ~/dotfiles
git remote set-url origin git@github.com:quaggaone/dotfiles.git
cd

# Stow dotfiles to home directory
echo "Stowing dotfiles into home directory..."
cd ~/dotfiles
./stow.sh

# Next steps
echo "Next Steps:"
echo "1. Install Homebrew from https://brew.sh"
echo "2. Configure System Settings using ~/dotfiles/defaults/system/index.sh"
echo "3. Install programms via brew using brew bundle install .Brewfile"
