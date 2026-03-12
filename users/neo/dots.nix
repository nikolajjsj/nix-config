{ ... }:
let
  home = {
    username = "neo";
    homeDirectory = "/home/neo";
    stateVersion = "25.11";
  };
in
{

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = home;

  imports = [
    ../../dots/zsh
    ../../dots/neofetch
    ../../dots/tmux
    ./gitconfig.nix
  ];

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;
}

