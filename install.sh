rm -rf ~/.pyenv
rm -rf ~/.zprofile
rm -rf ~/.zshrc
rm -rf ~/.oh-my-zsh
rm -rf ~/erb
cd ~

sudo apt update
sudo apt upgrade
sudo apt install -y curl git zsh

# for building python
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

# progresql server and admin tool
#
## Install the public key for the repository (if not done previously):
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

# Create the repository configuration file:
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

sudo apt install -y \
  postgresql \
  pgadmin4


# ohmyz : https://ohhmyz.sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# powerlevel9k : https://github.com/Powerlevel9k/powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# hack nerd font : https://www.nerdfonts.com/font-downloads
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip"


FONT_DIR="/usr/share/fonts/truetype/hack-nerd"

echo "→ Downloading Hack Nerd Font..."
wget -q "$FONT_URL" -O /tmp/hack-nerd.zip

echo "→ Extracting fonts..."
sudo mkdir -p "$FONT_DIR"
sudo unzip -q /tmp/hack-nerd.zip -d "$FONT_DIR"

echo "→ Updating font cache..."
sudo fc-cache -fv

echo "→ Cleaning up..."
rm -f /tmp/hack-nerd.zip

echo "✅ Hack Nerd Font installed to $FONT_DIR"


# zsh-syntax-hightlighting : https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# autosuggestion : https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md 
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# pyenv : https://github.com/pyenv/pyenv?tab=readme-ov-file#2-basic-github-checkout
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
touch ~/.zprofile
echo 'export PYENV_ROOT="$HOME/.pyenv"' | tee -a ~/.zshrc >> ~/.zprofile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' | tee -a ~/.zshrc >> ~/.zprofile
echo 'eval "$(pyenv init - zsh)"' | tee -a ~/.zshrc >> ~/.zprofile

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
pyenv install 3.10.17
pyenv install 3.11.12 
pyenv install 3.12.10
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

exec zsh -i -c '
chsh -s $(which zsh)
source ~/.envsetup/setup_proj.sh
loginctl terminate-user $USER
'
