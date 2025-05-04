{ inputs, lib, config, pkgs, ... }:
{
  home.packages = with pkgs; [
    tmux
  ];
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    extraConfig = ''
      # Leader key
      set -g prefix C-s

      # Default terminal
      set -g default-terminal "xterm-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set-option -g default-shell ${pkgs.zsh}/bin/zsh

      # Set the base index for windows and panes
      set-option -g base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Dont show the [ESC] delay
      set -s escape-time 0
      ## Enable mouse control (clickable windows, panes, resizable panes)
      set -g mouse on
      # Vim style
      set -g mode-keys vi
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      set -g status-position top

      # Reload TMUX config
      unbind r
      bind r source-file ~/.tmux.conf \; display "Reloaded!"
      '';
    plugins = with pkgs.tmuxPlugins; [
      yank 
    ];
  };
}
