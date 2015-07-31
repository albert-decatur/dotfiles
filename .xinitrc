# intended for crouton on chromebook
sudo rm /dev/dri/card0
sudo mv /dev/dri/card1 /dev/dri/card0
exec i3
