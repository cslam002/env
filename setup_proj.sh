
mkdir ~/erb
cd ~/erb
pyenv local 3.10.17

mkvirtualenv project1
workon project1

pip freeze
pip list
pip install --upgrade pip
pip install python-dotenv
pip install django==5.2
pip install django-debug-toolbar
pip install psycopg2
pip install pillow

django-admin startproject bcre .
python manage.py startapp pages

git init
cp ~/.envsetup/.gitignore.django ./.gitignore
