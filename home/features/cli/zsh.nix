{ config, lib, ... }:
with lib;
let
  cfg = config.features.cli.zsh;
in
{
  options.features.cli.zsh = {
    enable = mkEnableOption "Enable Zsh shell and configuration.";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      history.size = 10000;
      initContent = ''
        PS1='%F{blue}%B%~%b%f %F{green}❯%f '
        eval "$(fnm env --use-on-cd --shell zsh)"
      '';

      shellAliases = {
        nv = "nvim";
        ll = "eza -l -g --icons --git";
        lla = "ll -a";
        reload = "source ~/.zshrc"; # reloads current sessions
        ":q" = "exit"; # Exit like vim
        lg = "lazygit";

        # Recursively clean .DS_Store files
        cleanup = "find . -type f -name \"*.DS_Store\" -ls -delete";

        # Tmux Aliases
        t = "tmux";
        ta = "tmux attach -t";
        tl = "tmux ls";
        tk = "tmux kill-session -t";
        t-work = "tmux new-session -A -s work";
        t-dev = "tmux new-session -A -s personal";
      };
    };
  };
}
