cd ~
mkdir -p ~/temp/erb
cd ~/temp/erb
cp ~/erb/.env .
cp -rf ~/erb/media .
rm -rf ~/erb
git clone https://github.com/cslam002/erb6.git ~/erb
cd ~/erb
cp ~/temp/erb/.env .
cp -rf ~/temp/erb/media .
rm -rf ~/temp/erb
