#!/bin/bash

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

NEW_NAME="xxxCHANGEMExxx"
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

# Install Brew Apps
brew install --cask iterm2
brew install --cask brave-browser
brew install --cask google-chrome
brew install --cask firefox
brew install --cask telegram
brew install --cask discord
brew install --cask visual-studio-code
brew install --cask inkdrop
brew install --cask obsidian
brew install --cask 1password
brew install --cask spotify
brew install --cask raycast
brew install --cask zoom
brew install --cask vlc
brew install --cask audacity
brew install --cask obs
brew install --cask chatgpt
brew install 1password-cli
brew install github
brew install gitify
brew install --cask adobe-creative-cloud
brew install ffmpeg
brew install yt-dlp

brew tap ShakataGaNai/cask
brew install --cask cavalry

brew install --cask syncthing
open /Applications/Syncthing.app/
brew install --cask stats
open /Applications/Stats.app/
brew install --cask google-drive
brew install --cask elgato-control-center
open /Applications/Elgato\ Control\ Center.app

brew install podman kubectl helm skopeo buildah
brew install --cask podman-desktop
brew install cloudflare/cloudflare/cloudflared
brew install python@3
brew install asciinema ansible thefuck htop mtr pwgen nano lsd diff-so-fancy lolcat tree coreutils moreutils findutils wget curl git bgit-lfs dockutil mas

brew install zsh-completions zsh-autosuggestions zsh-syntax-highlighting powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

brew tap bramstein/webfonttools
brew install sfnt2woff sfnt2woff-zopfli woff2

brew install --cask font-droid-sans-mono-nerd-font
brew install --cask font-atkinson-hyperlegible
brew install --cask font-atkinson-hyperlegible-mono
brew install --cask font-atkinson-hyperlegible-next

git lfs install
curl -Lo ~/.dircolors.256dark https://raw.githubusercontent.com/seebi/dircolors-solarized/refs/heads/master/dircolors.256dark


git clone https://github.com/ShakataGaNai/dotfiles-macos.git ~/Development/dotfiles-macos
cp ~/Development/dotfiles-macos/dotfiles/zshrc ~/.zshrc
cp ~/Development/dotfiles-macos/dotfiles/gitconfig ~/.gitconfig
cp ~/Development/dotfiles-macos/dotfiles/nanorc ~/.nanorc
cp ~/Development/dotfiles-macos/dotfiles/tmux.conf ~/.tmux.conf
cp ~/Development/dotfiles-macos/dotfiles/curlrc ~/.curlrc
cp ~/Development/dotfiles-macos/dotfiles/ssh-config ~/.ssh/config
cp ~/Development/dotfiles-macos/dotfiles/p10k.zsh ~/.p10k.zsh

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
dockutil --no-restart -a /Applications/Discord.app/ -A Safari
dockutil --no-restart -a /Applications/Obsidian.app/ -A Safari
dockutil --no-restart -a "/Applications/Visual Studio Code.app/" -A Safari
dockutil --no-restart -a /Applications/Spotify.app/ -A Music
dockutil -a /Applications/ -p beginning --display folder --view grid

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
 "Reolink Client:1593161538"
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

### Doesn't work
# cp /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/SidebarPicturesFolder.icns ~/Screenshots/.VolumeIcon.icns
# SetFile -a C ~/Screenshots

# cp /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/SidebarUtilitiesFolder.icns ~/Development/.VolumeIcon.icns
# SetFile -a C ~/Development

# killall Finder



## Todo
# * iTerm Profile install
# * 

