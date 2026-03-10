#! /bin/bash

####### Run for ZSH only ######
# Recommend theme
# https://ohmyposh.dev/docs/themes
# 'craver', 'easy-term', 'kushal'

# --- VARIABLES ----------

OH_MY_POSH_THEME="kushal"
SHELL_EXPORTS="

# --- SOURCE DOTFILES SCRIPT ----------------------------

eval \"\$(oh-my-posh init zsh --config ~/.cache/oh-my-posh/themes/$OH_MY_POSH_THEME.omp.json)\"
"

# --- MAIN ----------

if [ ! -f ~/.zshrc ]; then
    touch ~/.zshrc
fi

# Write the theme configuration to .zshrc
if grep -q "# --- OH-MY-POSH INIT ----------------------------" ~/.zshrc; then
    echo "ZSH file config has already set the OH_MY_POSH_THEME variable. NO MODIFY !!!"
else
    cat <<EOF >> ~/.zshrc
$SHELL_EXPORTS
EOF
    echo "ZSH file config will set the OH_MY_POSH_THEME variable. MODIFY SUCCESSFULLY !!!"
fi