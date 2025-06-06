{ inputs, lib, config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
  };

  home.file."config" = {
    source = ./config;
  };
}
