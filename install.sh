#!/bin/bash
# Created by didiatworkz

_ANSIBLE_VERSION=7.1.0
_BRANCH=v3.1
#_BRANCH=master


header() {
tput setaf 172
cat << "EOF"
                            _
   ____                    | |
  / __ \__      _____  _ __| | __ ____
 / / _` \ \ /\ / / _ \| '__| |/ /|_  /
| | (_| |\ V  V / (_) | |  |   <  / /
 \ \__,_| \_/\_/ \___/|_|  |_|\_\/___|
  \____/                www.atworkz.de

EOF
echo
echo "Screenly OSE Monitor Add-On (SOMA)"
echo
echo
tput sgr 0
}

clear
header
echo "Prepair Screenly Player..."
sleep 2

if [ ! -e /home/pi/screenly/server.py ]
then
  echo -e "[ \e[32mNO\e[39m ] Screenly installed"
  echo -e "[ \e[93mYES\e[39m ] Standalone Installation"
  sudo mkdir -p /etc/ansible
  echo -e "[local]\nlocalhost ansible_connection=local" | sudo tee /etc/ansible/hosts > /dev/null
  sudo apt update
  sudo apt-get purge -y python-setuptools python-pip python-pyasn1 libffi-dev
  sudo apt-get install -y python3-dev git-core libffi-dev libssl-dev
  curl -s https://bootstrap.pypa.io/get-pip.py | sudo python3
  sudo pip3 install ansible=="$_ANSIBLE_VERSION"

else
  echo -e "[ \e[93mYES\e[39m ] Screenly installed"
fi

echo "The installation may take a while.."
echo
echo
echo
# Installing libpng-dev
echo "Installing libpng-dev and needed dependencies..."
sudo apt update
sudo apt-get install tcsh python3-dev nginx ansible libpng-dev -y
echo "Done installing libpng-dev and dependencies..."
echo "Changing Nginx default port to 8080"
sudo sed -i 's/listen 80 default_server;/listen 8080 default_server;/' /etc/nginx/sites-enabled/default
# Line below doesn't work, will fix later.
sudo sed -i 's/listen [::]:80 default_server;/listen [::]:8080 default_server;/' /etc/nginx/sites-enabled/default
echo "Done changing Nginx default port from 80 to 8080!"
echo "Installing Screenly OSE Monitor..."
sudo rm -rf /tmp/soma
sudo git clone https://github.com/markomi1/screenly-ose-monitoring-addon.git /tmp/soma
cd /tmp/soma
sudo -E ansible-playbook addon.yml

header
echo "Screenly OSE Monitor addon successfuly installed"
