path=(
  $HOME/bin
  $HOME/.cargo/bin
  $HOME/src/github.com/himanoa/git-subcommands/src
  $HOME/src/github.com/himanoa/git-subbcommands/src
  $GOPATH/bin
  $XDG_CONFIG_HOME/tmux/
  $path
  $HOME/.anyenv/bin
)
export FZF_TMUX=1
export EDITOR='nvim'
autoload -U compinit
compinit -u

### Added by Zplugin's installer
source "$HOME/.config/zsh/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

zplugin light zsh-users/zsh-autosuggestions
zplugin light zdharma/fast-syntax-highlighting
zplugin ice from"gh-r" as"program"
zplugin load junegunn/fzf-bin
zplugin light "chitoku-k/fzf-zsh-completions"

unsetopt prompt_subst;

bindkey -d
bindkey -e
alias vim='nvim'
alias buraro='git status -s | awk "{print $2}" | xargs rm -rf'

. $HOME/.fzf.zsh

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
autoload -U promptinit; promptinit
prompt pure

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

eval "$(anyenv init -)"
eval "$(direnv hook zsh)"
