sudo -v
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

#!/usr/bin/env zsh
mkdir ~/Development
mkdir ~/Wallpapers
mkdir ~/Desktop/Screenshots
mkdir ~/.ssh/
chmod 700 ~/.ssh/
mkdir -p ~/.config/git/template
echo "ref: refs/heads/main" | tee -a ~/.config/git/template/HEAD

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew upgrade
brew install --cask iterm2
brew install --cask brave-browser
brew install --cask telegram
brew install --cask discord
brew install --cask 1password
brew install --cask visual-studio-code
brew install --cask inkdrop
brew install python@3
brew install asciinema ansible thefuck htop mtr pwgen nano lsd

# Kubernetes Related
brew install k9s kubectl
brew install --cask lens

brew install coreutils
brew install moreutils
brew install findutils

brew install wget
brew install curl
#echo 'export PATH="/usr/local/opt/curl/bin:$PATH"' >> ~/.zshrc

# Font stuff
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2
# https://github.com/ryanoasis/nerd-fonts
brew tap homebrew/cask-fonts
# https://github.com/Homebrew/homebrew-cask-fonts/tree/master/Casks
brew install --cask font-droid-sans-mono-nerd-font

brew install git-lfs
git lfs install

wpfldr="$HOME/Wallpapers"
paper=$(ls -1 "$wpfldr" | sort --random-sort | head -1)
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'"$wpfldr/$paper"'"'

#brew tap dteoh/sqa
#brew install --cask slowquitapps

declare -a Apps=("Brave Browser" "iTerm" "Telegram" "Inkdrop" "Todoist" "Visual Studio Code" "1Password 7" "Discord")
for val in "${Apps[@]}"; do
    # For some reason I cannot get this to work via JSON. But the XML version works fine.
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/'"$val"'.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
done
killall Dock

################
curl -Lo ~/.dircolors.256dark https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
printf "${BLUE}####### ${RED}Once oh-my-zsh starts zsh, exit it to complete setup proccess ${BLUE}######${NC}\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

## Do some dotfiles
rm ~/.zshrc
ln -s $PWD/dotfiles/zshrc ~/.zshrc
ln -s $PWD/dotfiles/nanorc ~/.nanorc
rm ~/.gitconfig
ln -s $PWD/dotfiles/gitconfig ~/.gitconfig
ln -s $PWD/dotfiles/tmux.conf ~/.tmux.conf
ln -s $PWD/dotfiles/curlrc ~/.curlrc
ln -s $PWD/dotfiles/ssh-config ~/.ssh/config

ZSH_CUSTOM=~/.oh-my-zsh/custom/
ln -s $PWD/dotfiles/agnostersgn.zsh-theme $ZSH_CUSTOM/agnostersgn.zsh-theme
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions
curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

brew install zsh-syntax-highlighting
chmod -R go-w '/usr/local/share/zsh'
chmod -R go-w '/usr/local/share/zsh-completions'

./macos-defaults.sh
