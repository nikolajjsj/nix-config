{ inputs, lib, config, pkgs, ... }:
{
  home.packages = with pkgs; [
    aerospace
  ];

  # Source aerospace config from the home-manager store
  home.file.".aerospace.toml" = {
    source = ./aerospace.toml;
  };
}
