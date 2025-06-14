# Keep thisat the top
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH="/data/data/com.termux/files/home/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/data/data/com.termux/files/home/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/data/data/com.termux/files/home/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/data/data/com.termux/files/home/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/data/data/com.termux/files/home/perl5"; export PERL_MM_OPT;

# {{{ Tmux

    tmux_multisession()
    {
        # If there is an open, unattached tmux session: attach to it
        # Else, open a new tmux session
        if [[ -z "$TMUX" ]] && [[ -z "$NVIM_LISTEN_ADDRESS" ]]; then
            ID="$(tmux ls | grep -vm1 attached | cut -d: -f1)" # get the id of a deattached session
            export OLD_TERM="$TERM"
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
            export OLD_TERM="$TERM"
            if [[ -z "$TMUX" ]]; then
                if tmux -q has-session; then
                    exec tmux attach
                else
                    exec tmux new-session -e OLD_TERM="$TERM"
                fi
            fi
        fi
    }

    vim_session()
    {
        [ -z "$NVIM_LISTEN_ADDRESS" ] && exec nvim -c terminal
    }

    if [[ $TERM != xterm-kitty ]]; then
        tmux_multisession
    fi

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
# {{{ Colors

    # Translates ls colors to 'LS_COLORS'
    eval $(dircolors -b)
    export LS_COLORS="${LS_COLORS}:*.m2ts=01;35"
    export GREP_COLORS="mt=0;31"

# }}}
# {{{ Environment additions
    # {{{ Prompt
        reset_color='\e[0m'
        bold='\e[1m'
        swap='\e[7m'
        fg_red='\e[31m'
        bg_red='\e[41m'
        fg_blue='\e[34m'
        bg_blue='\e[44m'
        fg_black='\e[30m'
        bg_black='\e[40m'
        fg_white='\e[37m'
        bg_white='\e[47m'
        fg_bcbg='\e[37m'

        #if [[ "$TERM" == linux ]]; then
        #    # old style (simple)

        #    ESC_INDICATOR="\[$bold$fg_red\]>\[$reset_color\]"
        #    INS_INDICATOR=">"
        #    if [[ "$USER" == root ]]; then
        #        export home="$HOME"
        #        export HOME='/root'
        #        ESC_INDICATOR="\[$bold$fg_red\]#\[$reset_color\]"
        #        INS_INDICATOR="#"
        #    fi
        #    PROMPT="\! "
        #    PROMPT+="\[$bold$fg_blue\]%s\w "
        #    PROMPT+="\[$reset_color\]%s"'\q{keymap:vi/mode-indicator}'" "
        #else
        #    # breadcrumbs colors
        #    bcfg=white
        #    bcbg=foreground
        #fi
        ## Airline-ish (hybrid-theme)
        reset_color='[0m'
        norm='[7m'
        bold='[1m'
        swap='[7m'
        fg_red='[31m'
        bg_red='[41m'
        fg_green='[32m'
        bg_green='[42m'
        fg_yellow='[33m'
        bg_yellow='[43m'
        fg_blue='[34m'
        bg_blue='[44m'
        fg_black='[30m'
        bg_black='[40m'
        fg_white='[37m'
        bg_white='[47m'
        fg_bcbg='[37m'
        bg_bcfg="$bg_white"
        INSERT_INDICATOR="$bg_black INS $swap[7;47m"
        ESCAPE_INDICATOR="$bg_white$fg_black ESC $reset_color$swap[7;1;47m$reset_color[7;47m"
        REPLACE_INDICATOR="$bg_red$fg_black REP $reset_color$swap[7;1;41m$reset_color[7;47m"
        VREPLACE_INDICATOR="$bg_yellow$fg_black VRP $reset_color$swap[7;1;43m$reset_color[7;47m"
        VISUAL_INDICATOR="$bg_yellow$fg_black VIS $reset_color$swap[7;1;43m$reset_color[7;47m"
        SELECT_INDICATOR="$bg_white$fg_black SEL $reset_color$swap[7;1;47m$reset_color[7;47m"
        LINE_INDICATOR="$bg_white$fg_black LNE $reset_color$swap[7;1;47m$reset_color[7;47m"
        BLOCK_INDICATOR="$bg_white$fg_black BLK $reset_color$swap[7;1;47m$reset_color[7;47m"
        UNKNOWN_INDICATOR="$bg_white$fg_black ??? $reset_color$swap[7;1;47m$reset_color[7;47m"
        # '/' -> ''
        PS1_VIM_INDICATOR='$(if [[ "\q{keymap:vi/mode-indicator}" =~ INS ]]; then echo ${INSERT_INDICATOR}; elif [[ "\q{keymap:vi/mode-indicator}" =~ VREPL ]]; then echo ${VREPLACE_INDICATOR}; elif [[ "\q{keymap:vi/mode-indicator}" =~ REPL ]]; then echo ${REPLACE_INDICATOR}; elif [[ "\q{keymap:vi/mode-indicator}" =~ VISUAL ]]; then echo ${VISUAL_INDICATOR}; elif [[ "\q{keymap:vi/mode-indicator}" =~ SELECT ]]; then echo ${SELECT_INDICATOR}; elif [[ "\q{keymap:vi/mode-indicator}" =~ LINE ]]; then echo $LINE_INDICATOR; elif [[ "\q{keymap:vi/mode-indicator}" =~ BLOCK ]]; then echo ${BLOCK_INDICATOR}; else echo ${ESCAPE_INDICATOR};  fi)'
        PS1_CWD='$(echo \w | sed "s|'"$HOME"'|~/|;s/\///;s/\// ${bg_black}${bg_white} /g")'
        PS1="$PS1_VIM_INDICATOR $PS1_CWD $reset_color "

    # }}}
    # {{{ Default programs

        export PAGER="vimpager"
        export MANPAGER=vimmanpager
        export MANPAGER="nvim -c \"source $HOME/.config/nvim/lua/vimpager.lua | :Man! -\""
        [ -z "$EDITOR" ] && export EDITOR='nvim'
        [ -z "$SYSTEMD_EDITOR" ] && export SYSTEMD_EDITOR="$EDITOR"

    # }}}

    # {{{ Path Additions

        export PATH="$HOME/bin:$PATH"
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$PATH:$HOME/.cabal/bin"
        export PATH="$PATH:$HOME/.yarn/bin/"
        export PATH="$PATH:$HOME/.cargo/bin"
        export PATH="$HOME/.ghcup/bin:$PATH"
        export PATH="$PATH:/opt/appimages"
        export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
        # Python Completions (in console)
        export PYTHONSTARTUP="$HOME/.pythonrc.py"
        # PySpark
        # export PATH="$PATH:/opt/apache-spark/bin"
        #export PYTHONPATH="/opt/apache-spark/python/lib/py4j-0.10.7-src.zip:/opt/apache-spark/python"
        # export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab

        # export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

        #. ~/.databricks_tokens

    # }}}
# }}}
# {{{ Aliases

    make_alias() {
        org_cmd="$1"
        shift
        new_cmd="$*"
        alias $org_cmd="echo ❯ $new_cmd; $new_cmd"
    }

    make_alias      vim '$EDITOR --server ${XDG_RUNTIME_DIR}/nvim.socket'
    make_alias moviebot 'filebot -rename . -non-strict --format "{n} ({y})"'
    make_alias showbot 'filebot -rename . -non-strict --format "{n} - {s00e00} - {t}"'

    make_alias   fbmplayer 'mplayer -fs -vo fbdev -ao alsa'
    make_alias          ls 'ls --group-directories-first --color=auto'
    make_alias           l 'ls --group-directories-first --color=auto -F'
         alias        less='less -i -R -S'
    make_alias         bat 'bat --pager $HOME/bin/vim-scrollback'
    make_alias         mpv 'mpv --no-osc'
    make_alias       notes 'vim -c "VimwikiIndex"'
         alias          rg='rg --color always --heading --line-number'
         alias        diff='diff --unified --show-c-function'
    make_alias     gitdiff 'git difftool --no-symlinks --dir-diff'

    make_alias       magit 'vim -c MagitOnly'
    make_alias        wiki 'vim -c "VimwikiIndex"'

    make_alias           d 'dirs -v'
    make_alias        spim 'rlwrap spim'
    make_alias       paint 'classic-colors'
         alias    wl-paste='wl-paste -p'
    make_alias      record 'wf-recorder -g "$(slurp)" --audio=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor'
    make_alias         lua 'rlwrap --always-readline lua'
    make_alias      stylua 'stylua --config-path $HOME/.config/stylua/stylua.toml'

    # Doesn't work, but type this in exactly:
    #   pwgen -ncBy -r "\'"',^*!\\<>[]:`|;(){}~/$"' 15

# }}}

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Keep this at the bottom
[[ ! ${BLE_VERSION-} ]] || ble-attach
# exec zsh
