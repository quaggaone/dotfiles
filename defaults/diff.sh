#!/bin/bash

echo -n -e "\033[1m❓ Insert diff name (to store it for future usage)\033[0m "
read name
name=${name:-default}
echo -e "\033[1mSaving plist files to '$(pwd)/diffs/${name}' folder.\033[0m"

mkdir -p diffs/$name

# Group container prefs (e.g. group.com.apple.mail) are NOT captured by a bare
# `defaults read`, so read the plist files under ~/Library/Group Containers directly.
group_read() {
    for f in ~/Library/Group\ Containers/*/Library/Preferences/*.plist; do
        [ -f "$f" ] || continue
        echo "===== $f ====="
        plutil -p "$f" 2>/dev/null
    done
}

defaults read > diffs/$name/old.plist
defaults -currentHost read > diffs/$name/host-old.plist
group_read > diffs/$name/group-old.plist

echo -e "\n\033[1m⏳ Change settings and press any key to continue\033[0m"

read -n 1 -s -r
defaults read > diffs/$name/new.plist
defaults -currentHost read > diffs/$name/host-new.plist
group_read > diffs/$name/group-new.plist

echo -e "\033[1m➡️ Here is your diff\033[0m\n\n"
git --no-pager diff --no-index diffs/$name/old.plist diffs/$name/new.plist
echo -e '\n\n\033[1m➡️ and here with the `-currentHost` option\n\n'
git --no-pager diff --no-index diffs/$name/host-old.plist diffs/$name/host-new.plist
echo -e '\n\n\033[1m➡️ and here the group container prefs\n\n'
git --no-pager diff --no-index diffs/$name/group-old.plist diffs/$name/group-new.plist

echo -e "\n\n\033[1m🔮 Commands to print the diffs again\033[0m"
echo -e "$ git --no-pager diff --no-index diffs/${name}/old.plist diffs/${name}/new.plist"
echo -e "$ git --no-pager diff --no-index diffs/${name}/host-old.plist diffs/${name}/host-new.plist"
echo -e "$ git --no-pager diff --no-index diffs/${name}/group-old.plist diffs/${name}/group-new.plist"
