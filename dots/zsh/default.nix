{ inputs, lib, config, pkgs, ... }:
{
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws = {
          disabled = true;
        };
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    zsh = {
      enable = true;
      enableCompletion = false;
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "zsh-users/zsh-completions"; }
        ];
      };
      shellAliases = {
        ipp = "curl ipinfo.io/ip";
        nv = "nvim";
        la = "ls --color -lha";
        ll = "eza -l -g --icons --git";
        lla = "ll -a";
        reload = "source ~/.zshrc"; # reloads current sessions
        lg = "lazygit";
        # Tmux aliases
        t = "tmux";
        ta = "tmux attach -t";
        tl = "tmux ls";
        tk = "tmux kill-session -t";
      };

      initContent = ''
        # Editor
        export EDITOR="nvim"
        export VISUAL="nvim"
        export TERM="xterm"
        # Add colors to the terminal
        export CLICOLOR=1

        # Paths
        export NVM_DIR="$HOME/.nvm"
          [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
          [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
        export PNPM_HOME="/Users/nikolaj/Library/pnpm"
        export PATH="/opt/homebrew/bin:/Users/darwin/go/bin:$PNPM_HOME:$PATH"

        # FNM (Fast Node Manager) setup
        eval "$(fnm env --use-on-cd --corepack-enabled)"
      '';
    };
  };
}
