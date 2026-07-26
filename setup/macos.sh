#!/bin/bash

# Sane macOS defaults — based on https://mths.be/macos, trimmed to keys that
# still take effect on modern macOS (26 Tahoe).

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "Configuring macOS..."
else
  exit 0
fi

COMPUTERNAME='abereghici'
LOCALHOSTNAME='bereghicidev'

# Cache sudo and keep it alive until the script finishes
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2> /dev/null &

# --- General UI/UX ---

# Computer / host names
sudo scutil --set ComputerName $COMPUTERNAME
sudo scutil --set HostName $COMPUTERNAME
sudo scutil --set LocalHostName $LOCALHOSTNAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $LOCALHOSTNAME

# Faster window resizing
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Auto-quit the printer app when jobs finish
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Skip the "are you sure you want to open this app?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Graphite appearance, blue highlight
defaults write -g AppleAquaColorVariant -int 6
defaults write -g AppleHighlightColor -string '0.709800 0.835300 1.000000'

# --- Keyboard, language & input ---

# Full keyboard access for all controls (Tab in dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Language and formats
defaults write NSGlobalDomain AppleLanguages -array "en" "ro" "ru"
defaults write NSGlobalDomain AppleLocale -string "ro-MD@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Timezone (list: sudo systemsetup -listtimezones)
sudo systemsetup -settimezone "Europe/Bucharest" > /dev/null

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# --- Screen ---

# Require password immediately after sleep / screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Screenshots: PNG, to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# --- Finder ---

# Allow quitting via ⌘Q (also hides desktop icons)
defaults write com.apple.finder QuitMenuItem -bool true

# Show hidden files and all extensions
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Hide status bar, show path bar
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.finder ShowPathbar -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# No warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# No .DS_Store on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Skip disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Open a new window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Snap icons to a grid
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# List view by default (other modes: icnv, clmv, Flwv)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Unhide ~/Library
chflags nohidden ~/Library

# --- Dock ---

# Icon size
defaults write com.apple.dock tilesize -int 60

# Group windows by app in Mission Control
defaults write com.apple.dock expose-group-by-app -bool true

# Switch to a Space with the app's open windows
defaults write com.apple.dock workspaces-auto-swoosh -bool true

# Show only running apps
defaults write com.apple.dock static-only -bool true

# --- Spell checking ---

defaults write -g CheckSpellingWhileTyping -bool true
defaults write -g WebContinuousSpellCheckingEnabled -bool true

# --- WebKit ---

# Web Inspector in web views and the Mac App Store
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# --- Terminal ---

# UTF-8 only
defaults write com.apple.terminal StringEncodings -array 4

# --- Time Machine ---

# Don't prompt to use new disks as backup volumes
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# --- TextEdit ---

# Plain text, UTF-8
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# --- Power (pmset: -b battery, -c adapter) ---

sudo pmset -b sleep 10       # sleep after 10 min
sudo pmset -b displaysleep 5 # display off after 5 min
sudo pmset -b disksleep 10   # disk sleep after 10 min
sudo pmset -b lessbright 1   # dim on battery
sudo pmset -b halfdim 1      # dim before display sleep

sudo pmset -c sleep 30        # sleep after 30 min
sudo pmset -c displaysleep 10 # display off after 10 min
sudo pmset -c disksleep 10    # disk sleep after 10 min
sudo pmset -c womp 0          # don't wake for network access
sudo pmset -c halfdim 1       # dim before display sleep
sudo pmset -c autorestart 1   # restart after a power failure

# --- Restart affected apps ---

for app in "Contacts" "Calendar" "Dock" "Finder" \
  "Mail" "Safari" "SystemUIServer" "Terminal" "NotificationCenter"; do
  killall "$app" > /dev/null 2>&1
done

echo "Done. Some changes require a logout/restart to take effect."
