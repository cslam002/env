
mkdir ~/erb
cd ~/erb
pyenv local 3.10.17
source ~/.zshrc

mkvirtualenv project1
workon project1

pip freeze
pip list
pip install --upgrade pip
pip install python-dotenv
pip install django==5.2

django-admin startproject bcre .
python manage.py startapp pages

git init
cp ~/.envsetup/.gitignore.django ./.gitignore
