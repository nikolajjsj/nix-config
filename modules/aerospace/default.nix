{ inputs, lib, config, pkgs, ... }:
{
  programs.aerospace = {
    enable = true;
  };

  # Source aerospace config from the home-manager store
  home.file.".aerospace.toml" = {
    source = ./aerospace.toml;
  };
}
