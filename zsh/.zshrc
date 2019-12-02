export HM_PATH=https://github.com/rycee/home-manager/archive/master.tar.gz
OS_PREFIX='/usr'
[ -e /etc/nixos/configuration.nix  ] && OS_PREFIX=/run/current-system/sw
HM_SESSION="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
[ -e "$HM_SESSION"  ] && . "$HM_SESSION"; unset HM_SESSION
export OS_PREFIX

# {{{ Profiling

    # PROFILING=ON
    if [[ -n "$PROFILING" ]]; then
        zmodload zsh/datetime
        setopt promptsubst
        PS4='+$EPOCHREALTIME %N:%i> '

        # save file stderr to file descriptor 3 and redirect stderr
        # (including trace
        # output) to a file with the script's PID as an extension
        exec 3>&2 2>/tmp/startlog.$$
        # set options to turn on tracing and expansion of commands
        # contained in the prompt
        setopt xtrace prompt_subst
    fi
# }}}

# {{{ Initialization

    if [[ -n $SUDO_USER ]]; then
      export HOME=/home/$SUDO_USER
    fi

    setopt nosharehistory
    setopt histignorealldups
    setopt extendedglob
    setopt complete_aliases

# }}}

# {{{ Functions

printcal() {
    if [[ $(tput cols) -ge 80 ]] && [[ -z $SSH_CONNECTION ]]; then
        echo -n '[1;32m'; rem -cu+1; echo -n '[0m'
    fi
    rem -q | tail -n +2
}

ext-ip () { curl http://ipecho.net/plain; echo; }
insert_sudo () { zle beginning-of-line; zle -U "sudo "; }
insert_sudo_vi () { zle beginning-of-line; zle -U "isudo "; }

egraph()
{
    emacsclient -a "" -c "$@" &
    disown %emacsclient
}

econs()
{
    emacsclient -a "" -nw "$@"
}

# }}}

# {{{ Tmux

    tmux_multisession()
    {
        # If there is an open, unattached tmux session: attach to it
        # Else, open a new tmux session
        if [[ -z "$TMUX" ]] && [[ -z "$NVIM_LISTEN_ADDRESS" ]]; then
            ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
            if [[ -z "$ID" ]] ;then # if not available create a new one
                exec tmux new-session
            else
                exec tmux attach-session -t "$ID" # if available attach to it
            fi
        fi
    }

    tmux_singlesession()
    {
        if which tmux >/dev/null 2>&1; then
            #if not inside a tmux session, and if no session is started, start a new session
            if [[ -z "$TMUX" ]]; then
                if tmux -q has-session; then
                    exec tmux attach
                else
                    exec tmux new-session
                fi
            fi
        fi
    }

    vim_session()
    {
        [ -z "$NVIM_LISTEN_ADDRESS" ] && exec nvim -c terminal
    }

    tmux_multisession


    stty stop '' -ixoff # Disable C-S command in any programs

    # tmux and urxvt titles
    case $TERM in
      screen*)
        precmd() {
          # Restore tmux-title to 'zsh'
          printf "\033kzsh\033\\"
          print -Pn "\e]2;%~\a"
        }
        preexec(){
          # set tmux-title to running program
          printf "\033k%s\033\\" "$(echo "$1" | cut -d" " -f1)"
          # set urxvt-title to running program
          print -Pn "\e]2;$(echo "$1" | cut -d" " -f1)\a"
        }
        ;;
    esac

# }}}

# {{{ SSH Opts

    if [[ -z "$DISPLAY" ]]; then
        export DISPLAY=:0
    fi

    # if this is an ssh session, print out info about the last ssh login
    if [ "$SSH_CONNECTION" ]; then
        lastlogarr=("${(@f)$(last -a -F -n 2 "$USER")}")
        lastLogAddr=$(echo "$lastlogarr[2]" | awk '{print $NF}')
        lastLogDate=$(echo "$lastlogarr[2]" |\
            awk '{printf("%s %s %s %s %s", $3, $4, $5, $6, $7)}')
        echo "Last login:"
        echo "    $lastLogDate from $lastLogAddr"
    fi
# }}}

# {{{ Colors

    # Translates ls colors to 'LS_COLORS'
    eval "$(dircolors -b "$HOME/.dircolors")"
    LS_COLORS+="*pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:"
    LS_COLORS+="*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:"

    export GREP_COLOR="0;31"

# }}}

# {{{ Plugins

    if [[ ! -d $HOME/.zgen ]]; then
        git clone https://github.com/tarjoilija/zgen "$HOME/.zgen"
    fi

    # {{{ zgen
        source ~/.zgen/zgen.zsh

        if ! zgen saved; then
            zgen prezto
            zgen prezto 'environment'
            zgen prezto 'terminal'
            zgen prezto 'history'
            zgen prezto 'directory'
            zgen prezto 'spectrum'
            zgen prezto 'utility'
            zgen prezto 'completion'
            zgen prezto 'ssh'
            zgen prezto 'command-not-found'
            zgen prezto 'prompt'

            zgen load "b4b4r07/emoji-cli"
            zgen load 'felixgravila/zsh-abbr-path'
            zgen load 'Tarrasch/zsh-functional'
            zgen load 'rylnd/shpec'
            zgen load 'zsh-users/zsh-autosuggestions'
            zgen load 'zdharma/fast-syntax-highlighting'

            zgen load 'qfjp/k'

            zgen save
        fi

        . $HOME/.zgen/felixgravila/zsh-abbr-path-master/.abbr_pwd
        FAST_HIGHLIGHT_STYLES[comment]="fg=magenta,bold"

        ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
            forward-char
            end-of-line
            vi-forward-char
            vi-end-of-line
        )

    # }}}

    autoload -U deer

# }}}

# {{{ Environment additions

    setopt nocorrectall

    # load math library
    # ex. $((sin(1)))
    zmodload zsh/mathfunc

    # {{{ Prompt

        export KEYMAP=main
        autoload -U colors && colors

        if [[ "$TERM" == linux ]]; then
            # old style (simple)

            ESC_INDICATOR="%{$fg_bold[red]%}>%{$reset_color%}"
            INS_INDICATOR=">"
            if [[ "$USER" == root ]]; then
                export home="$HOME"
                export HOME='/root'
                ESC_INDICATOR="%{$fg_bold[red]%}#%{$reset_color%}"
                INS_INDICATOR="#"
            fi
            PROMPT="%! "
            PROMPT+="%{$fg_bold[blue]%}%s%~ "
            PROMPT+="%{$reset_color%}%s"'$(vi_mode_prompt_info)'" "
        elif [[ -n $NIX_STORE ]]; then
            bcfg=black
            bcbg=blue
        else
            # breadcrumbs colors
            bcfg=white
            bcbg=foreground
        fi
        ## Airline-ish (hybrid-theme)

        INS_INDICATOR="%{$bg[black]%} %! %{[7m$fg[$bcbg]%}"
        ESC_INDICATOR="%{$bg[white]$fg[black]%} %! %{[0m[7m$fg[$bcbg]$bg[white]%}"

        setopt PROMPT_SUBST
        # esc/ins indicator
        PROMPT=$'\n''$(vi_mode_prompt_info)'"%{$reset_color[7m$fg[$bcbg]$bg[$bcfg]%}"
        # Directory with godawful-looking divider replacement ( '/' -> '' )
        path_hole="|%-1~ / … / %3~|"
        PROMPT+=" \${\${\${\${(%):-"'$(felix_pwd_abbr)'"}#/}//\// %{$bg[black]%\}%{$bg[$bcfg]%\} }:-"/"} "
        PROMPT+="%{$reset_color$fg[$bcbg]%} "

        function zle-line-init zle-keymap-select {
          zle reset-prompt
        }

        zle -N zle-line-init
        zle -N zle-keymap-select

        bindkey -v

        # if mode indicator wasn't setup by theme, define default
        if [[ "$ESC_INDICATOR" == "" ]]; then
          ESC_INDICATOR="%{$fg[red]%}>>%{$fg_bold[red]%}>%{$reset_color%}"
        fi

        if [[ "$INS_INDICATOR" == "" ]]; then
          INS_INDICATOR="UNSET!!!"
        fi

        function vi_mode_prompt_info() {
          echo -n "${${KEYMAP/vicmd/$ESC_INDICATOR}/(main|viins)/}"
          echo -n "${${KEYMAP/main/$INS_INDICATOR}/(vicmd|viins)/}"
        }
        unset RPROMPT

    # }}}

    # {{{ History

        HISTSIZE=5000
        SAVEHIST=$HISTSIZE
        HISTFILE=~/.zsh_history

    # }}}

    # {{{ Default programs

        export PAGER="vimpager"
        export MANPAGER="nvim -R -S $HOME/.config/nvim/vimpagerrc -c 'set ft=man' -"
        export MANPATH="$(manpath):/usr/share/man"
        [ -z "$EDITOR" ] && export EDITOR='nvim'

    # }}}

    # {{{ Path Additions

        export PATH="$HOME/bin:$PATH"
        export PATH="$PATH:$HOME/.local/bin"
        export PATH="$HOME/bin/macros:$PATH"
        export PATH="$PATH:$HOME/.cabal/bin"
        export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
        # PySpark
        export PYTHONPATH="/opt/apache-spark/python/lib/py4j-0.10.7-src.zip:/opt/apache-spark/python"
        export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab

    # }}}

# }}}

# {{{ Aliases

    alias moviebot='filebot -rename . -non-strict --format "{n} ({y})"'
    alias showbot='filebot -rename . -non-strict --format "{n} - {s00e00} - {t}"'

    alias         vim='$EDITOR'
    alias   fbmplayer='mplayer -fs -vo fbdev -ao alsa'
    alias        gksu='gksudo'
    alias          ls='ls --group-directories-first --color=auto'
    alias           l='ls --group-directories-first --color=auto -F'
    alias        less='less -R'
    alias         mpv='mpv --no-osc'
    alias       notes='vim -c "VimwikiIndex"'
    alias          rm='nocorrect rm'
    alias     yaourtc='yaourt --color'

    alias       magit='vim -c MagitOnly'
    alias        wiki='vim -c "VimwikiIndex"'

    alias           d='dirs -v'
    alias        spim='rlwrap spim'

# }}}

# {{{ Completion

    for profile in ${(z)NIX_PROFILES}; do
        fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
    done


    zstyle ':completion:*' verbose yes
    zstyle ':completion:*:descriptions' format '%B%d%b'
    zstyle ':completion:*:messages' format '%d'
    zstyle ':completion:*:warnings' format 'No matches for: %d'
    zstyle ':completion:*' group-name
    zstyle ":completion:*:commands" rehash 1
    autoload -U compinit && compinit

# }}}

# {{{ Zle keybindings

     # Quote text objects
     autoload -U select-quoted
     zle -N select-quoted
     for m in visual viopp; do
       for c in {a,i}{\',\",\`}; do
         bindkey -M $m $c select-quoted
       done
     done

    autoload edit-command-line
    zle -N edit-command-line

    # key binding fixes - zshzle is the zsh equivalent to bash's readline
    export KEYTIMEOUT=50 # shorten the amount of time for a two-key binding

    typeset -Ag DEER_KEYS
    DEER_KEYS[quit]=''
    zle -N deer
    bindkey -M vicmd 'o'  deer # ranger-like file browser
    bindkey -M viins ''  deer # ranger-like file browser

    bindkey          '^?'     backward-delete-char            # Fix 'backspace'
    bindkey          '^H'     backward-delete-char            # Fix 'backspace'
    bindkey          '^[[1~'  beginning-of-line               # Fix 'home'   (ins)
    bindkey          '^[[4~'  end-of-line                     # Fix 'end'    (ins)
    bindkey          '^[[3~'  delete-char                     # Fix 'delete' (ins)
    bindkey -M vicmd 'i'      vi-insert                # bind 'jk' to <Esc>
    bindkey -M viins 'jk'     vi-cmd-mode                     # bind 'jk' to <Esc>
    bindkey -M viins '^[[2~'  beep                            # Kill 'insert'
    bindkey -M viins '^[[5~'  beep                            # Kill 'pg-up'
    bindkey -M viins '^[[6~'  beep                            # Kill 'pg-dn'
    bindkey -M viins '^[[29~' beep                            # Kill 'menu'

    # Fucking awesome up/down history completion
    bindkey -M vicmd 'k'      up-line-or-search
    bindkey -M vicmd 'j'      down-line-or-search

    # for use with substring-search plugin
    bindkey -M viins '^P'      up-line-or-search
    bindkey -M viins '^N'      down-line-or-search
    bindkey -M vicmd '^P'      history-substring-search-up
    bindkey -M vicmd '^N'      history-substring-search-down

    bindkey -M viins '^[[A'   up-line-or-search
    bindkey -M viins '^[[B'   down-line-or-search

    bindkey -M vicmd '^[[1~'  beginning-of-line               # Fix 'home'
    bindkey -M vicmd '^[[4~'  end-of-line                     # Fix 'end'
    bindkey -M vicmd '^[[3~'  delete-char                     # Fix 'delete'
    bindkey -M vicmd 'gg'     beginning-of-buffer-or-history  # bind 'gg' to hist-top
    bindkey -M vicmd 'u'      undo                            # fix vi-undo
    bindkey -M vicmd '^R'     redo                            # fix vi-undo
    # key to edit current command in external editor
    bindkey -M vicmd 'v'      edit-command-line
    # Note that '?' wont work, because you'll only be able to search one step back
    bindkey          '^R' history-incremental-search-backward

    bindkey -r -M vicmd -- '-'  # '-' is too close to '0', and fucks me up

    # Ctrl-s inserts sudo at the start of a line
    zle -N insert-sudo insert_sudo
    zle -N insert-sudo-vi insert_sudo_vi
    bindkey -M viins "^s" insert-sudo # Ctrl-s
    bindkey -M vicmd "^s" insert-sudo-vi # Ctrl-s

    # {{{ greek characters

        bindkey -s '^[a' "α"
        bindkey -s '^[b' "β"
        bindkey -s '^[c' "χ"
        bindkey -s '^[d' "δ"
        bindkey -s '^[e' "ε"
        bindkey -s '^[f' "φ"
        bindkey -s '^[g' "γ"
        bindkey -s '^[h' "η"
        bindkey -s '^[i' "ι"
        bindkey -s '^[j' "ϑ"
        bindkey -s '^[k' "κ"
        bindkey -s '^[l' "λ"
        bindkey -s '^[m' "μ"
        bindkey -s '^[n' "ν"
        bindkey -s '^[o' "o"
        bindkey -s '^[p' "π"
        bindkey -s '^[q' "θ"
        bindkey -s '^[r' "ρ"
        bindkey -s '^[s' "σ"
        bindkey -s '^[t' "τ"
        bindkey -s '^[u' "υ"
        bindkey -s '^[v' "ς"
        bindkey -s '^[w' "ω"
        bindkey -s '^[x' "ξ"
        bindkey -s '^[y' "ψ"
        bindkey -s '^[z' "ζ"

        bindkey -s '^[A' "Α"
        bindkey -s '^[B' "Β"
        bindkey -s '^[C' "Χ"
        bindkey -s '^[D' "Δ"
        bindkey -s '^[E' "Ε"
        bindkey -s '^[F' "Φ"
        bindkey -s '^[G' "Γ"
        bindkey -s '^[H' "Η"
        bindkey -s '^[I' "Ι"
        bindkey -s '^[J' "Θ"
        bindkey -s '^[K' "Κ"
        bindkey -s '^[L' "Λ"
        bindkey -s '^[M' "Μ"
        bindkey -s '^[N' "Ν"
        bindkey -s '^[O' "Ο"
        bindkey -s '^[P' "Π"
        bindkey -s '^[Q' "Θ"
        bindkey -s '^[R' "Ρ"
        bindkey -s '^[S' "Σ"
        bindkey -s '^[T' "Τ"
        bindkey -s '^[U' "Υ"
        bindkey -s '^[V' "Σ"
        bindkey -s '^[W' "Ω"
        bindkey -s '^[X' "Ξ"
        bindkey -s '^[Y' "Ψ"
        bindkey -s '^[Z' "Ζ"

    # }}}


    # {{{ other math characters

        bindkey -s '^[1' "∇"

    # }}}

# }}}


# {{{ Finish profiling

    if [[ -n "$PROFILING" ]]; then
        # turn off tracing
        unsetopt xtrace
        # restore stderr to the value saved in FD 3
        exec 2>&3 3>&-
        unset PROFILING
    fi

# }}}

# {{{ FZF

    FZF_DIR="$(dirname "$(readlink -e "$(which fzf)")")/../share/fzf"
    if [[ -d $FZF_DIR ]]; then
        [[ $- == *i* ]] && source "$FZF_DIR/completion.zsh" 2> /dev/null
        source "$FZF_DIR/key-bindings.zsh"
    fi
    unset FZF_DIR
    export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    FZF_DEFAULT_OPTS="--height 50% --border --reverse "
    FZF_CTRL_T_OPTS+='--preview '"'"'case "$(file --mime {})" in
      *binary*) echo {} is a binary file;;
      *) vimcat.sh {};;
      esac'"'"
    export FZF_DEFAULT_OPTS

    bindkey '^E' fzf-cd-widget


    # GIT heart FZF - https://junegunn.kr/2016/07/fzf-git/
    # -------------

    is_in_git_repo() {
      git rev-parse HEAD > /dev/null 2>&1
    }

    fzf-down() {
      fzf --height 50% "$@" --border
    }

    gf() {
      is_in_git_repo || return
      git -c color.status=always status --short |
      fzf-down -m --ansi --nth 2..,.. \
        --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
      cut -c4- | sed 's/.* -> //'
    }

    gb() {
      is_in_git_repo || return
      git branch -a --color=always | grep -v '/HEAD\s' | sort |
      fzf-down --ansi --multi --tac --preview-window right:70% \
        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
      sed 's/^..//' | cut -d' ' -f1 |
      sed 's#^remotes/##'
    }

    gt() {
      is_in_git_repo || return
      git tag --sort -version:refname |
      fzf-down --multi --preview-window right:70% \
        --preview 'git show --color=always {} | head -'$LINES
    }

    gn() {
      is_in_git_repo || return
      git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
      fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
        --header 'Press CTRL-S to toggle sort' \
        --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
      grep -o "[a-f0-9]\{7,\}"
    }

    gr() {
      is_in_git_repo || return
      git remote -v | awk '{print $1 "\t" $2}' | uniq |
      fzf-down --tac \
        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
      cut -d$'\t' -f1
    }

    join-lines() {
      local item
      while read item; do
        echo -n "${(q)item} "
      done
    }

    bind-git-helper() {
      local char
      for c in $@; do
        eval "fzf-g$c-widget() { local result=\$(g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
        eval "zle -N fzf-g$c-widget"
        eval "bindkey '^g^$c' fzf-g$c-widget"
      done
    }
    bind-git-helper f b t r n
    unset -f bind-git-helper

# }}}
