> These scripts are supposed to be structured like the corresponding View in the System Setting apps or their settings.
> Most of of the options and values where found by changing the values in the settings app and checking what changed with the `diff` script from the [macos-defaults.com](https://macos-defaults.com) project.
> The nix-darwin documentation was also helpful for an overview and type lookup.

> Some things like the Safari `plist` require Full Disk Access.

# Setup Steps and Notes
1. Run the `bootstrap.sh` script using `curl -L URL | sh` (test this)
   It will download Xcode cli-tools and clone the repo to your local `~/dotfiles` folder. Then it will symlink all relevant dotfiles into your home directory.

- The scripts are supposed to behave like a config that's loaded (not natively possible in macOS; possible with something like [nix-darwin](https://github.com/LnL7/nix-darwin/)). So the idea is that you should be able to run these scripts as many times as you want while getting the same result every time.


- Run the necessary executables in the `defaults/system` folder
- Manually configure the following settings:
    - Display Settings
    - Disable Auto Join on Guest Networks
    - Enable "Unlock with Apple Watch"
    - Password Autofill Settings after installing Password Manager
    - Login Items & Extensions when installing/configuring individual apps
    - Internet Accounts (and Mailbox Behaviour in Mail Settings, espacially Google Accounts)
    - VPNs (also VPN Menu Bar item after configuring)
    - Wallpaper & Screensaver
    - Notification Settings (always when opening an app for the first time)
    - Lock Screen Options (idle times and Lock Screen message)
    - Turn off "Personalized Ads" in Privacy > Apple Advertising
    - Touch ID settings
    - iCloud settings (Private Relay etc.)
    - Wallet & Apple Pay
    - App Store: disable In-App Ratings & Reviews
- Copy SSH config and keys into `~/.ssh` folder
- Configure `~/.gitconfig`

## AeroSpace

Tiling window manager for macOS. Manages workspaces across monitors and handles automatic app placement, keybindings, and layout rules.

Workspaces are purpose-driven: numbered (1–6) for general use, named for fixed contexts — C: communication, M: media, N: notes, X: mail. All keybindings use `ctrl+alt+cmd` as the base modifier, mapped to a single Hyper key via Karabiner-Elements.

### Sketchybar integration

The menubar reflects workspace state in real time. Switching workspaces, moving windows, and opening or closing apps all notify Sketchybar to redraw the affected workspace indicators automatically.

## addtitional resources
- [This script (https://github.com/brunerd/macAdminTools/blob/99da3d3dd1155019758a7753075aea13db6ad3b2/Scripts/iCloudPrivateRelayStatus.sh#L36)](https://github.com/brunerd/macAdminTools/blob/99da3d3dd1155019758a7753075aea13db6ad3b2/Scripts/iCloudPrivateRelayStatus.sh#L36) can check whether iCloud Private Relay is running. Maybe this can be used to set the status as well.
