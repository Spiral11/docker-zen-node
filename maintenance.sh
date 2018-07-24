#Update apps / system
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get clean

#Clean docker images to free disk space
sudo docker system prune -a
