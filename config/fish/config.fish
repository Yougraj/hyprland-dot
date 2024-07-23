set -g fish_greeting

if status is-interactive
    starship init fish | source
end

# List Directory
alias  l='eza -l  --icons'
alias ls='eza -1  --icons'
alias ll='eza -la --icons'
alias ld='eza -lD --icons'

alias in='sudo pacman -S' # install package
alias un='sudo pacman -Rns' # uninstall package
alias up='sudo pacman -Syu' # update system/package/aur
alias pl='pacman -Qs' # list installed package
alias pa='pacman -Ss' # list availabe package
alias pc='sudo pacman -Sc' # remove unused cache
alias po='pacman -Qtdq | sudo pacman -Rns -' # remove unused packages, also try > pacman -Qqd | pacman -Rsu --print -

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'
abbr v 'nvim'

export PATH="$PATH/var/lib/snapd/snap/bin/flutter:$PATH"
export PATH="$PATH:/var/lib/snapd/snap/bin"
export PATH="/usr/bin/flutter/bin:$PATH"
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
