#! /bin/bash

sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update
sudo apt install fish -y

if grep -Fxq "[ -f ~/.oh-my-posh-init ] && source ~/.oh-my-posh-init" $HOME/.bashrc
    echo "Fish command has already been at bash startup. NO MODIFY !!!"
else
    echo "fish" | tee -a $HOME/.bashrc
    echo "\nFish command at bash startup". MODIFY SUCCESSFULLY !!!
end
