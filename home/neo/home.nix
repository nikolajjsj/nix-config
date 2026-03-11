{ config, lib, pkgs, ... }:
let
  user = "neo";
in
{
  imports = [
    ../../dots/zsh
    ../../dots/tmux
    ../../dots/neofetch
  ];

  home = {
    stateVersion = "25.11";
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = [ ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
