{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [ grc ];

  age.secrets.bwSession = {
    file = "${inputs.secrets}/bwSession.age";
  };

  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        nv = "nvim";
        ll = "eza -l -g --icons --git";
        lla = "ll -a";
        reload = "source ~/.zshrc"; # reloads current sessions
        :q = "exit"; # Exit like vim
        lg = "lazygit";
        # Git aliases
        gs = "git status"; # Shows the current git STATUS
        ga = "git add"; # Add files for a git commit
        gA = "git add ."; # Adds all changed files for the next commit
        gc = "git commit"; # Uses default editor for a commit message
        gcne = "git commit --amend --no-edit"; # Amends to previous commit
        gac = "gA && gc"; # Combination of adding all recent changes and git commit

        # Recursively clean .DS_Store files
        cleanup = "find . -type f -name \"*.DS_Store\" -ls -delete";

        # Tmux Aliases
        t = "tmux";
        ta = "tmux attach -t";
        tl = "tmux ls";
        tk = "tmux kill-session -t";
        t-work = "tmux new-session -A -s work";
        t-dev = "tmux new-session -A -s personal";

        # Only do `nix flake update` if flake.lock hasn't been updated within an hour
        deploy-nix = "f() { if [[ $(find . -mmin -60 -type f -name flake.lock | wc -c) -eq 0 ]]; then nix flake update; fi && deploy .#$1 --remote-build -s --auto-rollback false && rsync -ax --delete ./ $1:/etc/nixos/ };f";
      };

      initExtra = ''

# Editor
      export EDITOR="nvim"
      export VISUAL="nvim"
      export TERM="xterm"

# Add colors to the terminal
      export CLICOLOR=1

# Kill leftover server
      function killport() { lsof -i TCP:$1 | grep LISTEN | awk '{print $2}' | xargs kill -9 }

# Paths
      export NVM_DIR="$HOME/.nvm"
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
        [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
      export PNPM_HOME="/Users/nikolaj/Library/pnpm"
      export PATH="/opt/homebrew/bin:/Users/darwin/go/bin:$PNPM_HOME:$PATH"
      . "$HOME/.cargo/env"

# fzf
      source <(fzf --zsh)

# Purification
# by Matthieu Cneude
# https://github.com/Phantas0s/purification

# Based on:

# Purity
# by Kevin Lanni
# https://github.com/therealklanni/purity
# MIT License

# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

# Display git status
# TODO to refactor with switch / using someting else than grep
# Might be faster using ripgrep too
      git_prompt_status() {
        local INDEX STATUS

        INDEX=$(command git status --porcelain -b 2> /dev/null)

        STATUS=""

        if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
        fi

        if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
        elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
        elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
        fi

        if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
        elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
        elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
        elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
        fi

        if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
        fi

        if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
        elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
        elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
        fi

        if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
          STATUS="$ZSH_THEME_GIT_PROMPT_STASHED$STATUS"
        fi

        if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
        fi

        if $(echo "$INDEX" | grep '^## [^ ]\+ .*ahead' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD$STATUS"
        fi

        if $(echo "$INDEX" | grep '^## [^ ]\+ .*behind' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND$STATUS"
        fi

        if $(echo "$INDEX" | grep '^## [^ ]\+ .*diverged' &> /dev/null); then
          STATUS="$ZSH_THEME_GIT_PROMPT_DIVERGED$STATUS"
        fi

        if [[ ! -z "$STATUS" ]]; then
          echo " [ $STATUS]"
        fi
      }


      prompt_git_branch() {
          autoload -Uz vcs_info 
          precmd_vcs_info() { vcs_info }
          precmd_functions+=( precmd_vcs_info )
          setopt prompt_subst
          zstyle ':vcs_info:git:*' formats '%b'
      }

      prompt_git_info() {
          [ ! -z "$vcs_info_msg_0_" ] && echo "$ZSH_THEME_GIT_PROMPT_PREFIX%F{white}$vcs_info_msg_0_%f$ZSH_THEME_GIT_PROMPT_SUFFIX"
      }

      prompt_purity_precmd() {
          # Pass a line before each prompt
          print -P ""
      }

      prompt_purification_setup() {
          # Display git branch

          autoload -Uz add-zsh-hook
          add-zsh-hook precmd prompt_purity_precmd

          ZSH_THEME_GIT_PROMPT_PREFIX=" %F{red}λ%f:"
          ZSH_THEME_GIT_PROMPT_DIRTY=""
          ZSH_THEME_GIT_PROMPT_CLEAN=""

          ZSH_THEME_GIT_PROMPT_ADDED="%F{green}+%f "
          ZSH_THEME_GIT_PROMPT_MODIFIED="%F{blue}%f "
          ZSH_THEME_GIT_PROMPT_DELETED="%F{red}x%f "
          ZSH_THEME_GIT_PROMPT_RENAMED="%F{magenta}➜%f "
          ZSH_THEME_GIT_PROMPT_UNMERGED="%F{yellow}═%f "
          ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{white}%f "
          ZSH_THEME_GIT_PROMPT_STASHED="%B%F{red}%f%b "
          ZSH_THEME_GIT_PROMPT_BEHIND="%B%F{red}%f%b "
          ZSH_THEME_GIT_PROMPT_AHEAD="%B%F{green}%f%b "

          prompt_git_branch
          RPROMPT='$(prompt_git_info) $(git_prompt_status)'
          PROMPT=$'%F{white}%~ %B%F{blue}>%f%b '
      }

      prompt_purification_setup
      '';
    };
  };
}
