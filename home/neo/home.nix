{ config, lib, pkgs, ... }:
let
  user = "neo";
in
{
  imports = [
    ../../modules/neovim
    ../features/cli
  ];

  features = {
    cli = {
      zsh.enable = true;
      fzf.enable = true;
    };
  };

  home = {
    stateVersion = "24.11";
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = [ ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
