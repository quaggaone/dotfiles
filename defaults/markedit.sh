#!/bin/bash

# symlink settings file
ln -siF ~/dotfiles/.config/markedit/settings.json $HOME/Library/Containers/app.cyan.markedit/Data/Documents/settings.json
ln -siF ~/dotfiles/.config/markedit/editor.css $HOME/Library/Containers/app.cyan.markedit/Data/Documents/editor.css

defaults write app.cyan.markedit WebAutomaticSpellingCorrectionEnabled -bool false
