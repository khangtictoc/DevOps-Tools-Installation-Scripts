#! /usr/bin/fish

####### Run for FISH only ######
# Recommend theme
# https://ohmyposh.dev/docs/themes
# 'craver', 'easy-term'
set THEME "kushal"
set APPLIED_SHELL "fish"
oh-my-posh init $APPLIED_SHELL --config ~/.cache/oh-my-posh/themes/$THEME.omp.json > ~/.oh-my-posh-init
source ~/.oh-my-posh-init

# Config for fish at statup with fish
if grep -Fxq "[ -f ~/.oh-my-posh-init ] && source ~/.oh-my-posh-init" ~/.config/fish/config.fish
    echo "Fish file config has already source the ~/.oh-my-posh-init at fish startup. NO MODIFY !!!"
else
    echo -n "[ -f ~/.oh-my-posh-init ] && source ~/.oh-my-posh-init" | tee -a ~/.config/fish/config.fish
    echo "\nFish file config will source the ~/.oh-my-posh-init at fish startup". MODIFY SUCCESSFULLY !!!
end


