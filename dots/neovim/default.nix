{ inputs, lib, config, pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = lib.fileContents ./init.lua;
  };
  environment.variables.EDITOR = "nvim";
}
