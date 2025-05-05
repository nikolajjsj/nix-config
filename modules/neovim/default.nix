{ inputs, lib, config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = lib.fileContents ./init.lua;
  };
}
