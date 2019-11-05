path=(
  $HOME/.cargo/bin
  $HOME/src/github.com/himanoa/git-subcommands/src
  $GOPATH/bin
  ~/.anyenv/bin(N-/)
  $path
)
export FZF_TMUX=1
export EDITOR='nvim'
autoload -U compinit
compinit -u



powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh

### Added by Zplugin's installer
source "$HOME/.config/zsh/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

zplugin light zsh-users/zsh-autosuggestions
zplugin light zdharma/fast-syntax-highlighting
zplugin ice from"gh-r" as"program"
zplugin load junegunn/fzf-bin

unsetopt prompt_subst;

almel_preexec() {
    ALMEL_START="$EPOCHREALTIME"
}

almel_precmd() {
    STATUS="$?"
    NUM_JOBS="$#jobstates"
    END="$EPOCHREALTIME"
    DURATION="$(($END - ${ALMEL_START:-$END}))"
    PROMPT="$(almel prompt zsh -s"$STATUS" -j"$NUM_JOBS" -d"$DURATION")"
    unset ALMEL_START
}

almel_setup() {
    autoload -Uz add-zsh-hook

    add-zsh-hook precmd almel_precmd
    add-zsh-hook preexec almel_preexec
}

almel_setup

bindkey -d
bindkey -e
alias vim='nvim'

eval "$(anyenv init -)"
. $HOME/.fzf.zsh

function ghq_cd() {
  cd $(ghq root)/$(ghq list | fzf-tmux)
}
function gst() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        git status
        git status -sb
    fi
}
autoload -z edit-command-line
zle -N ghq_cd ghq_cd
zle -N edit-command-line
bindkey "^X^E" ghq_cd
fpath=(/usr/local/share/zsh-completions ${fpath})
eval "$(direnv hook zsh)"
