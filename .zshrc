# NOW IN .zshrc
# PS1="%B%F{034}%n@%m%f%b:%B%F{019}%~ %#%f%b "
# PS1="%B%F{045}%n~%B%F{053}%#%f%b "
# PROMPT='%F{208}%n%f in %F{226}%~%f -> '
# PROMPT='%F{cyan}%n%f:~$'
# PROMPT='%F{032}%n%f:%F{032}%~%f '

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '[%b]'
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST


DEFAULT_THEME='%F{green}|%*|%f:%F{032}%~/%F{green}'
GITHUB_THEME='%F{cyan}|%*|%f:%F{blue}%~/%F{magenta}'
PINK_UNICORN='%F{pink}|%*|%f:%F{yellow}%~/%F{blue}'
OCEAN_BLUE='%F{cyan}|%*|%f:%F{green}%~/%F{yellow}'
FIRE_ORANGE='%F{yellow}|%*|%f:%F{red}%~/%F{green}'
GRAPEFRUIT='%F{magenta}|%*|%f:%F{blue}%~/%F{magenta}'
MINT_GREEN='%F{green}|%*|%f:%F{cyan}%~/%F{white}'
LAVENDER='%F{magenta}|%*|%f:%F{blue}%~/%F{cyan}'
SUNFLOWER='%F{yellow}|%*|%f:%F{green}%~/%F{yellow}'
ROYAL_PURPLE='%F{blue}|%*|%f:%F{red}%~/%F{magenta}'
CANDY_APPLE='%F{red}|%*|%f:%F{yellow}%~/%F{green}'
GRAYSCALE_GRAY='%F{white}|%*|%f:%F{gray}%~/%F{white}'
GRAYSCALE_GREEN='%F{white}|%*|%f:%F{gray}%~/%F{green}'
GRAYSCALE_CYAN='%F{white}|%*|%f:%F{gray}%~/%F{cyan}'
GRAYSCALE_BLUE='%F{white}|%*|%f:%F{gray}%~/%F{blue}'


 theme=$DEFAULT_THEME
 theme=$GITHUB_THEME
# theme=$PINK_UNICORN
# theme=$OCEAN_BLUE
# theme=$FIRE_ORANGE
# theme=$GRAPEFRUIT
# theme=$MINT_GREEN
# theme=$LAVENDER
# theme=$SUNFLOWER
# theme=$ROYAL_PURPLE
# theme=$CANDY_APPLE

# theme=$GRAYSCALE_GRAY
# theme=$GRAYSCALE_GREEN
# theme=$GRAYSCALE_CYAN
# theme=$GRAYSCALE_BLUE

PROMPT=$theme'${vcs_info_msg_0_}%f> '

alias ls="ls -G"
alias llh="ls -alFh"
alias ll="ls -alFg"
alias l="ls -aF"
alias kpdo="keep_doing"
alias kpx="keep_executing"
alias mongod="mongod --dbpath=/Users/vahan.sahakyan/data/db"
alias vim="nvim"
alias idea='open -a "`ls -dt /Applications/IntelliJ\ IDEA*|head -1`"'
alias lld="ll | grep -E '/' --color"
alias mysql="mysql -u root -p"
alias findtext="find . -type f -exec cat {} "
alias till="tmux ls | awk 'BEGIN{FS=\":\"}!/attached/{print $1}' | xargs -n 1 tmux kill-ses -t"
# git config --global alias.hs "log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%x09%x09 %Creset%s %C(auto)%d' --date=relative --date-order"
alias gs="git status"
alias ghs="git hs"
alias gb="git branch"
alias gout="git checkout"
alias gmit="git add -A; git commit"


export PATH=/usr/local/bin:$PATH
export PATH=~/scripts:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -Uz compinit && compinit


useclear() {
  preexec () {
    clear
  }
}

# bun completions
[ -s "/Users/vahan.sahakyan/.bun/_bun" ] && source "/Users/vahan.sahakyan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=${PATH}:/usr/local/mysql/bin/
export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
