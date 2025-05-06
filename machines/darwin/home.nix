{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  # Basics
  home.username = "darwin";
  home.homeDirectory = "/Users/darwin";
  home.packages = [ ];

  imports = [
    ../../modules/neovim/default.nix
    ../../modules/zsh/default.nix
  ];
}
