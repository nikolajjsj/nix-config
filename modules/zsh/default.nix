{ inputs, pkgs, lib, config, ... }:
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      history.size = 10000;
      # extra config
      initContent = ''
        PS1='%F{blue}%B%~%b%f %F{green}❯%f '
      '';

      shellAliases = {
        nv = "nvim";
        ll = "eza -l -g --icons --git";
        lla = "ll -a";
        reload = "source ~/.zshrc"; # reloads current sessions
        ":q" = "exit"; # Exit like vim
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
    };
  };
}

