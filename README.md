> These scripts are supposed to be structured like the corresponding View in the System Setting apps or their settings.
> Most of of the options and values where found by changing the values in the settings app and checking what changes with the diff script from the [](macos-defaults.com) project.
> The nix-darwin documentation was also helpful for an overview and type lookup.

> Some things like the Safari plist require Full Disk Access.

# Setup Steps and Notes
1. Run the `bootstrap.sh` script using `curl -s URL | sh` (test this)
   It will download Xcode cli-tools and clone the repo to your local `~/dotfiles` folder. Then it will download and install Homebrew for Apple Silicon and install GNU `stow` to symlink all dotfiles into your home folder.

- The scripts are supposed to behave like a config that's loaded (not natively possible in macOS; if you want see something like [nix-darwin](https://github.com/LnL7/nix-darwin/)). So the idea is that you should be able to run these scripts as many times as you want while getting the same result every time.


- Run the necessary executables in the `system` folder
- Manually configure the follwing:
    - Display Settings
    - Disable Auto Join on Guest Networks
    - Enable "Unlock with Apple Watch"
    - Password Autofill Settings after installing Passowrd Manager
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


## to do
- [ ] automatically populate Finder Spawn folder with most important symlinks (check if to use symlinks or macOS native Aliases)
- [ ] turn off automatically save documents to iCloud (Finder or System Settings idk)
