export CARGO_HOME="$HOME/.cargo"
path=(
  $HOME/bin
  $HOME/.cargo/bin
  $HOME/src/github.com/himanoa/git-subcommands/src
  $HOME/src/github.com/himanoa/git-subbcommands/src
  $GOPATH/bin
  $XDG_CONFIG_HOME/tmux/
  $path
  $HOME/src/github.com/himanoa/git-subcommands/src
  $CARGO_HOME/bin
  /opt/asdf-vm
)
fpath+=$HOME/.zsh/pure
export FZF_TMUX=1
export GOPATH=$HOME
export EDITOR='nvim'
export HISTSIZE=1000
export FZF_DEFAULT_OPTS="--tiebreak=index --ansi --border"
export FZF_DEFAULT_COMMAND="fd --color always"
export FZF_TMUX=1
export ASDF_CONFIG_FILE=~/.asdfrc

export SAVEHIST=100000

setopt hist_ignore_dups

setopt EXTENDED_HISTORY
autoload -U compinit
compinit -u

bindkey -d
bindkey -e
alias vim='nvim'
alias buraro='git status -s | awk "{print $2}" | xargs rm -rf'

function ghq_cd() {
  cd $(ghq root)/$(ghq list | fzf-tmux)
}
function gst() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        git status -sb
    fi
}
autoload -z edit-command-line
zle -N ghq_cd ghq_cd
zle -N edit-command-line
bindkey "^X^E" ghq_cd
fpath=(/usr/local/share/zsh-completions ${fpath})

export HISTFILE=${HOME}/.zsh_history

export HISTSIZE=1000

export SAVEHIST=100000

setopt hist_ignore_dups

setopt EXTENDED_HISTORY
function precmd() {
  if [ ! -z $TMUX ]; then
    tmux refresh-client -S
  fi
}

## fzf-zsh-completions/rails.zsh

_fzf_complete_rails() {
  if [[ "$@" =~ '^rails (generate|g)' ]]; then
      _fzf_complete_rails-generators '' "$@"
      return
  fi

  _fzf_path_completion "$prefix" "$@"
}

_fzf_complete_rails-generators() {
  shift
  _fzf_complete "" "rails g "  < <(
    rails g --help | sed -ne '/^Please/,$p' | sed '/^ *$/d' | sed -ne '/^ /p' | sed 's/^[ ]*//g'
  ) 
}

_fzf_complete_rails-generators_post() {
    awk '{ print $0 }'
}


_fzf_complete_make() {
  _fzf_complete "--ansi --tiebreak=index $fzf_options" $@ < <(grep -E '^[a-zA-Z_-]+:.*?$$' Makefile | sort | awk -F ':' '{ print $1 }')
}


## fzf-zsh-completions/asdf.zsh
_fzf_complete_asdf() {
  if [[ "$@" =~ '^asdf install (.*) ' ]]; then
    _fzf_complete_asdf-install '' "$match[1]" "$@"
    return
  fi

  _fzf_path_completion "$prefix"  "$@"
}

_fzf_complete_asdf-install() {
  shift
  _fzf_complete "--ansi --tiebreak=index $fzf_options" "asdf install "$1" " < <(asdf list-all "$1" | sort)
}

_fzf_complete_asdf-install_post() {
    awk '{ print $0 }'
}


_fzf_complete_make() {
  _fzf_complete "--ansi --tiebreak=index $fzf_options" $@ < <(grep -E '^[a-zA-Z_-]+:.*?$$' Makefile | sort | awk -F ':' '{ print $1 }')
}

eval "$(direnv hook zsh)"
. $HOME/.asdf/asdf.sh
. ~/.asdf/plugins/java/set-java-home.zsh
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit

autoload -Uz compinit
compinit
source ~/.config/zsh/antigen/bin/antigen.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle from"gh-r" as"program"
antigen bundle chitoku-k/fzf-zsh-completions
antigen apply

almel_preexec() {
    ALMEL_START="$EPOCHREALTIME"
}

almel_precmd() {
    STATUS="$?"
    NUM_JOBS="$#jobstates"
    END="$EPOCHREALTIME"
    DURATION=0
    PROMPT="$(almel prompt zsh -s"$STATUS" -j"$NUM_JOBS" -d"$DURATION")"
    unset ALMEL_START
}

almel_setup() {
    autoload -Uz add-zsh-hook

    add-zsh-hook preexec almel_preexec
    add-zsh-hook precmd almel_precmd
}

almel_setup
