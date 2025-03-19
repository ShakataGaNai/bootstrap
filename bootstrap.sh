#!/bin/zsh

# Invoke this script: /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ShakataGaNai/dotfiles-macos/main/bootstrap.sh)"

doPause() {
  local msg="${1:-Press Enter to continue or Ctrl+C to exit...}"
  echo "$msg"
  #read -k 1 -s < /dev/tty
  #echo
}

doPause "Keystroke testing"

function test_keystroke() {
  osascript <<EOF
  tell application "System Events"
      try
          keystroke tab using {command down}
      on error
          display dialog "Terminal needs Accessibility permissions.\n\nGo to System Settings > Privacy & Security > Accessibility and enable Terminal." buttons {"OK"}
          return "FAIL"
      end try
  end tell
EOF
}

if [[ "$(test_keystroke)" == "FAIL" ]]; then
    echo "Please enable Accessibility permissions for Terminal, then rerun the script."
    exit 1
fi

doPause "Prompts"

echo -n "Enter the new computer name: "
read computer_name < /dev/tty
NEW_NAME=$(echo "$computer_name" | tr '[:lower:]' '[:upper:]')

WP=""

# Loop until valid input received
while [[ "$WP" != "W" && "$WP" != "P" ]]; do
    # Request user input
    echo -e "Please select your environment type: (W)ork or (P)ersonal?"
    echo -n "> "
    
    read choice < /dev/tty
    
    # Convert input to uppercase
    WP=$(echo "$choice" | tr '[:lower:]' '[:upper:]')
    
    # Check if valid
    if [[ "$WP" != "W" && "$WP" != "P" ]]; then
        echo -e "Invalid selection. Please enter W or P."
    fi
done

echo "Setting up $NEW_NAME as a $WP machine."

doPause "Computer name, dirs & homebrew"

sudo scutil --set ComputerName "$NEW_NAME"
sudo scutil --set HostName "$NEW_NAME"
sudo scutil --set LocalHostName "$NEW_NAME"
dscacheutil -flushcache

mkdir ~/Development
mkdir ~/Wallpapers
mkdir ~/Screenshots
mkdir ~/.ssh/
chmod 700 ~/.ssh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Rosetta 2
softwareupdate --install-rosetta --agree-to-license

doPause "Installing Apps"

# Install Brew Apps

if [[ "$WP" == "P" ]]; then
    echo "Installing personal apps"
    brew install --cask discord
    brew install --cask audacity
    brew install --cask obs
    brew install --cask adobe-creative-cloud
    brew install gitify
    brew install ffmpeg
    brew install yt-dlp

    brew tap ShakataGaNai/cask
    brew install --cask cavalry

    brew install --cask syncthing
    open /Applications/Syncthing.app/
fi

echo "Installing all apps"
brew install dockutil
brew install mas

brew install --cask iterm2
brew install --cask brave-browser
brew install --cask google-chrome
brew install --cask firefox
brew install --cask telegram
brew install --cask visual-studio-code
brew install --cask inkdrop
brew install --cask obsidian
brew install --cask 1password
brew install 1password-cli
brew install --cask spotify
brew install --cask raycast
brew install --cask zoom
brew install --cask vlc
brew install --cask chatgpt
brew install github
brew install --cask stats
open /Applications/Stats.app/
brew install --cask google-drive
brew install --cask elgato-control-center
open /Applications/Elgato\ Control\ Center.app

brew install podman kubectl helm skopeo
brew install --cask podman-desktop
brew install cloudflare/cloudflare/cloudflared
brew install python@3
brew install asciinema ansible thefuck htop mtr pwgen nano lsd diff-so-fancy \
 lolcat tree coreutils moreutils findutils wget curl git git-lfs
git lfs install

brew install zsh-completions zsh-autosuggestions zsh-syntax-highlighting powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

brew tap bramstein/webfonttools
brew install sfnt2woff sfnt2woff-zopfli woff2

brew install --cask font-meslo-lg-nerd-font
brew install --cask font-droid-sans-mono-nerd-font
brew install --cask font-atkinson-hyperlegible
brew install --cask font-atkinson-hyperlegible-mono
brew install --cask font-atkinson-hyperlegible-next

curl -Lo ~/.dircolors.256dark https://raw.githubusercontent.com/seebi/dircolors-solarized/refs/heads/master/dircolors.256dark

doPause "Setting up dotfiles"
git clone https://github.com/ShakataGaNai/dotfiles-macos.git ~/Development/dotfiles-macos
cp ~/Development/dotfiles-macos/dotfiles/zshrc ~/.zshrc
cp ~/Development/dotfiles-macos/dotfiles/gitconfig ~/.gitconfig
cp ~/Development/dotfiles-macos/dotfiles/nanorc ~/.nanorc
cp ~/Development/dotfiles-macos/dotfiles/tmux.conf ~/.tmux.conf
cp ~/Development/dotfiles-macos/dotfiles/curlrc ~/.curlrc
cp ~/Development/dotfiles-macos/dotfiles/ssh-config ~/.ssh/config
cp ~/Development/dotfiles-macos/dotfiles/p10k.sh ~/.p10k.sh


if [[ "$WP" == "W" ]]; then
    echo -n "Enter your work email: "
    read email_input < /dev/tty
    sed -i '' "s/email = github@konsoletek.com/email = $email_input/" ~/.gitconfig
fi

doPause "Dockutil"

dockutil --no-restart -r Mail
dockutil --no-restart -r Maps
dockutil --no-restart -r Launchpad
dockutil --no-restart -r Contacts
dockutil --no-restart -r Reminders
dockutil --no-restart -r Freeform
dockutil --no-restart -r TV
dockutil --no-restart -r News
dockutil --no-restart -r Keynote
dockutil --no-restart -r Numbers
dockutil --no-restart -r Pages
dockutil --no-restart -r Downloads
dockutil --no-restart -a /Applications/iTerm.app/ -p beginning 
dockutil --no-restart -a "/Applications/Brave Browser.app/" -B Safari
dockutil --no-restart -a "/Applications/Google Chrome.app/" -B Safari
dockutil --no-restart -a /Applications/1Password.app/ -A Safari
dockutil --no-restart -a /Applications/Telegram.app/ -A Safari
dockutil --no-restart -a /Applications/Obsidian.app/ -A Safari
dockutil --no-restart -a "/Applications/Visual Studio Code.app/" -A Safari
dockutil --no-restart -a /Applications/Spotify.app/ -A Music
if [[ "$WP" == "P" ]]; then
    dockutil --no-restart -a /Applications/Discord.app/ -A Safari
fi
dockutil --no-restart -a /Applications/ -p beginning --display folder --view grid
defaults write com.apple.dock orientation -string right && killall Dock

# Apps to install
install_apps=(
 "1Password for Safari:1569813296"
 "Flighty:1358823008"
 "Next DNS:1464122853"
 "Parcel:639968404"
 "Session:1521432881"
 "Slack:803453959"
 "Todoist:585829637"
 "Tailscale:1475387142"
 "OpenInterface KVM:6478481082"
 "Kagi for Safari:1622835804"
 "Apple Developer:640199958"
)

# Apps to uninstall
uninstall_apps=(
 "Keynote:409183694"
 "iMovie:408981434"
 "Pages:409201541"
 "Garage Band:682658836"
 "Numbers:409203825"
)

doPause "App Store"

for app in "${install_apps[@]}"; do
  name="${app%%:*}"
  id="${app##*:}"
  echo "Installing $name..."
  mas install "$id"
done

for app in "${uninstall_apps[@]}"; do
  name="${app%%:*}"
  id="${app##*:}"
  echo "Uninstalling $name..."
  sudo mas uninstall "$id"
done

doPause "System Preferences"

defaults write -g com.apple.swipescrolldirection -boolean NO

defaults write com.apple.screencapture location ~/Screenshots
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the ~/Library folder
chflags nohidden ~/Library

# Bottom left screen corner+Cmd → Lock
defaults write com.apple.dock wvous-bl-corner -int 13
defaults write com.apple.dock wvous-bl-modifier -int 1048576

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable Sonoma "click to reveal desktop" feature
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

killall SystemUIServer

curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash


doPause "Finder Favorites & other OAS"

# Add screenshots and finder to finder favorites, can't find a better way to do this.
osascript <<EOF
tell application "Finder"
    activate
    delay 1
    set targetFolder to POSIX file "/Users/$USER/Screenshots"
    tell application "System Events"
        keystroke "n" using {command down, shift down}
        delay 1
        tell process "Finder"
            set frontmost to true
            delay 1
            keystroke "g" using {command down, shift down}
            delay 1
            keystroke "/Users/$USER/Screenshots"
            delay 0.5
            keystroke return
            delay 1
            keystroke "t" using {control down, command down}
        end tell
    end tell
end tell
EOF

osascript <<EOF
tell application "Finder"
    activate
    delay 1
    set targetFolder to POSIX file "/Users/$USER/Development"
    tell application "System Events"
        keystroke "n" using {command down, shift down}
        delay 1
        tell process "Finder"
            set frontmost to true
            delay 1
            keystroke "g" using {command down, shift down}
            delay 1
            keystroke "/Users/$USER/Development"
            delay 0.5
            keystroke return
            delay 1
            keystroke "t" using {control down, command down}
        end tell
    end tell
end tell
EOF

# Do P10k configuration for iTerm2
local k t v settings=(
'"Normal Font"'                                 string '"MesloLGS-NF-Regular '18'"'
'"Terminal Type"'                               string '"xterm-256color"'
'"Horizontal Spacing"'                          real   1
'"Vertical Spacing"'                            real   1
'"Minimum Contrast"'                            real   0
'"Use Bold Font"'                               bool   1
'"Use Bright Bold"'                             bool   1
'"Use Italic Font"'                             bool   1
'"ASCII Anti Aliased"'                          bool   1
'"Non-ASCII Anti Aliased"'                      bool   1
'"Use Non-ASCII Font"'                          bool   0
'"Ambiguous Double Width"'                      bool   0
'"Draw Powerline Glyphs"'                       bool   1
'"Only The Default BG Color Uses Transparency"' bool   1
)
for k t v in $settings; do
/usr/libexec/PlistBuddy -c "Set :\"New Bookmarks\":0:$k $v" ~/Library/Preferences/com.googlecode.iterm2.plist 
/usr/libexec/PlistBuddy -c "Add :\"New Bookmarks\":0:$k $t $v" ~/Library/Preferences/com.googlecode.iterm2.plist
done

### Doesn't work
# cp /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/SidebarPicturesFolder.icns ~/Screenshots/.VolumeIcon.icns
# SetFile -a C ~/Screenshots

# cp /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/SidebarUtilitiesFolder.icns ~/Development/.VolumeIcon.icns
# SetFile -a C ~/Development

# killall Finder



## Todo
# * iTerm Profile install
# * 

