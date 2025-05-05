{ config, pkgs, ... }:

{
  # Basics
  home.username = "darwin";
  home.homeDirectory = "/Users/darwin";

  home.stateVersion = "24.11"; # Don't touch if not needed.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    neovim
  ];

  home.sessionVariables = {
     EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
