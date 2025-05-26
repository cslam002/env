#!/bin/zsh
rm -rf ~/.pyenv
rm -rf ~/.zprofile
rm -rf ~/.zshrc*
rm -rf ~/.oh-my-zsh
rm -rf ~/erb

sudo apt update
sudo apt upgrade
sudo apt install -y curl git zsh

sudo apt install -y \
  build-essential \
  zlib1g-dev \
  libssl-dev \
  libffi-dev \
  libsqlite3-dev \
  libreadline-dev \
  libbz2-dev \
  liblzma-dev \
  tk-dev

echo $SHELL
chsh -s $(which zsh)

cd ~

# ohmyz : https://ohhmyz.sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# powerlevel9k : https://github.com/Powerlevel9k/powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# hack nerd font : https://www.nerdfonts.com/font-downloads
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip

# zsh-syntax-hightlighting : https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# autosuggestion : https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md 
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# pyenv : https://github.com/pyenv/pyenv?tab=readme-ov-file#2-basic-github-checkout
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init - zsh)"' >> ~/.zshrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' > ~/.zprofile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile
echo 'eval "$(pyenv init - zsh)"' >> ~/.zprofile

pyenv install 3.10.17
pyenv install 3.11.12 
pyenv global 3.11.12

# virtualenvwrapper : https://github.com/pyenv/pyenv-virtualenvwrapper
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper



echo 'export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"' >> ~/.zshrc
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.zshrc
echo 'export VIRTUALENVWRAPPER_PYTHON=$(pyenv which python)' >> ~/.zshrc
echo 'pyenv virtualenvwrapper_lazy' >> ~/.zshrc

echo 'source $HOME/.envsetup/zsh_custom.sh' >> ~/.zshrc

replacements=(
  'ZSH_THEME="powerlevel9k/powerlevel9k"'
  'plugins=(git pyenv virtualenv zsh-autosuggestions zsh-syntax-highlighting)'
)

for new_line in "${replacements[@]}"; do
  key="${new_line%%=*}"
  sed -i -E "/^[[:space:]]*${key}[[:space:]]*=/c\\${new_line}" ~/.zshrc
done

source ~/.envsetup/setup_git.sh
source ~/.envsetup/setup_proj.sh

exec "$SHELL"
sudo reboot now
