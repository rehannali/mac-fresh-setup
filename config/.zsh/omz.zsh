ZSH_THEME="spaceship"
ZSH_DISABLE_COMPFIX="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS=true
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
  poetry
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-256color
  fast-syntax-highlighting
  zsh-autocomplete
)

source $ZSH/oh-my-zsh.sh