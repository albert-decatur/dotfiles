## intended for crouton on chromebook
# for Asus c201
if [[ -n /dev/dri/card0 ]]; then 
    sudo rm /dev/dri/card0 && sudo mv /dev/dri/card1 /dev/dri/card0
else 
    false
fi
# start i3 wm
exec i3
