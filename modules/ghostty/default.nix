{ inputs, lib, config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
  };

  # Source aerospace config from the home-manager store
  home.file."config" = {
    source = ./config;
  };
}
