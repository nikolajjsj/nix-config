{ config, lib, pkgs, ... }:
let
  user = "neo";
in
{
  imports = [
    ../../modules/neovim
    ../../modules/zsh
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
    sessionVariables = {
      EDITOR = "neovim";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
