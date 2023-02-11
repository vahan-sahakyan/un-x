# Define theme variables
DEFAULT_ZSH_THEME="\[\033[00;32m\]|\t|\[\033[00m\]:\[\033[00;36m\]\w/\[\033[01;32m\]"
GITHUB_THEME="\[\033[00;36m\]|\t|\[\033[00m\]:\[\033[01;34m\]\w/\[\033[01;35m\]"
PINK_UNICORN="\[\033[00;31m\]|\t|\[\033[00m\]:\[\033[01;33m\]\w/\[\033[01;34m\]"
OCEAN_BLUE="\[\033[00;36m\]|\t|\[\033[00m\]:\[\033[01;32m\]\w/\[\033[01;33m\]"
FIRE_ORANGE="\[\033[00;33m\]|\t|\[\033[00m\]:\[\033[01;31m\]\w/\[\033[01;32m\]"
GRAPEFRUIT="\[\033[00;35m\]|\t|\[\033[00m\]:\[\033[01;34m\]\w/\[\033[01;35m\]"
MINT_GREEN="\[\033[00;32m\]|\t|\[\033[00m\]:\[\033[01;36m\]\w/\[\033[01;37m\]"
LAVENDER="\[\033[00;35m\]|\t|\[\033[00m\]:\[\033[01;34m\]\w/\[\033[01;36m\]"
SUNFLOWER="\[\033[00;33m\]|\t|\[\033[00m\]:\[\033[01;32m\]\w/\[\033[01;33m\]"
ROYAL_PURPLE="\[\033[00;34m\]|\t|\[\033[00m\]:\[\033[01;31m\]\w/\[\033[01;35m\]"
CANDY_APPLE="\[\033[00;31m\]|\t|\[\033[00m\]:\[\033[01;33m\]\w/\[\033[01;32m\]"

GRAYSCALE_GRAY="\[\033[01;37m\]|\t|\[\033[00m\]:\[\033[01;30m\]\w/\[\033[01;37m\]"
GRAYSCALE_GREEN="\[\033[01;37m\]|\t|\[\033[00m\]:\[\033[01;30m\]\w/\[\033[01;32m\]"
GRAYSCALE_CYAN="\[\033[01;37m\]|\t|\[\033[00m\]:\[\033[01;30m\]\w/\[\033[01;36m\]"
GRAYSCALE_BLUE="\[\033[01;37m\]|\t|\[\033[00m\]:\[\033[01;30m\]\w/\[\033[01;34m\]"

# theme=$DEFAULT_ZSH_THEME
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

function setps1() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    bname=$(git symbolic-ref HEAD 2> /dev/null | awk -F '/' '{print $NF}')
    branch="[${bname:-HEAD}]"
  else
    branch=""
  fi

  # Combine all
  RESULT_THEME="$theme$branch\[\033[00m\]> "

  # Set PS1 with result theme
  PS1=$RESULT_THEME
}


PROMPT_COMMAND=setps1

alias ls="ls -G"
alias llh="ls -alFh"
alias ll="ls -alF"
alias l="ls -aF"
alias kpdo="keep_doing"
alias kpx="keep_executing"alias mongod="mongod --dbpath=/Users/vahan.sahakyan/data/db"

export PATH=/usr/local/bin:$PATH
export PATH=~/scripts:$PATH

if [ -n "$BASH_VERSION" ]; then
    setps1
fi