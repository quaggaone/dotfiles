#!/bin/zsh

# Source the utility script
source "$(dirname "$0")/utils.sh"

# Domain for Dock preferences
SAFARI_DOMAIN="com.apple.Safari"

##########
# SAFARI #
##########

## View options
set_defaults "$SAFARI_DOMAIN" "ShowOverlayStatusBar" "bool" "true"	# Show Status Bar to see URLs at the bottom


## Settings
### General
set_defaults "$SAFARI_DOMAIN" "ExcludePrivateWindowWhenRestoringSessionAtLaunch" "bool" "false"		# Restore all windows when restarting
set_defaults "$SAFARI_DOMAIN" "HistoryAgeInDaysLimit" "int" "365000"	# remove history items after (365000 -> manually)
set_defaults "$SAFARI_DOMAIN" "AlwaysPromptForDownloadFolder" "bool" "true"		# file download location

### this always ask for file download location should work like this but it doesn't (still manually have to set it in the safari settings). also the diff script for detecting changes does not show anything useful when changing this setting (sequoia 15.5 2025-06-08)
set_defaults "$SAFARI_DOMAIN.SandboxBroker" "AlwaysPromptForDownloadFolder" "bool" "true"		# file download location
# set_defaults "$SAFARI_DOMAIN.SandboxBroker" "DidMigrateDownloadFolderToSandbox" "bool" "true"		# file download location
# set_defaults "$SAFARI_DOMAIN.SandboxBroker" "DidMigrateResourcesToSandbox" "bool" "true"		# file download location

set_defaults "$SAFARI_DOMAIN" "AutoOpenSafeDownloads" "bool" "false"	# open "safe" files after downloading

### Tabs
set_defaults "$SAFARI_DOMAIN" "ShowStandaloneTabBar" "bool" "false"	# compact tab bar

### AutoFill
set_defaults "$SAFARI_DOMAIN" "AutoFillFromAddressBook" "bool" "false"	# autofill from my contacts

### Search
set_defaults "$SAFARI_DOMAIN" "SearchProviderShortName" "string" "DuckDuckGo"		# search engine

### Advanced
set_defaults "$SAFARI_DOMAIN" "IncludeDevelopMenu" "bool" "true"	# Show Developer options
set_defaults "$SAFARI_DOMAIN" "EnableEnhancedPrivacyInRegularBrowsing" "bool" "true"	# use advandved tracking prevention in all browsing modes
set_defaults "$SAFARI_DOMAIN" "WebKitPreferences.privateClickMeasurementEnabled" "bool" "false"		# allow privacy-preserving measurement of ad-effectiveness
set_defaults "$SAFARI_DOMAIN" "ReadingListSaveArticlesOfflineAutomatically" "bool" "true"		# reading list: save articles for offline reading

# Restart Safari to apply changes
echo "Restarting Safari to apply changes..."
killall Safari

echo "Safari settings updated!"

