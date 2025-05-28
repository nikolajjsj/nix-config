{ config, lib, ... }:
{
  options.homelab.services = {
    enable = lib.mkEnableOption "Settings and services for the homelab";
  };

  config = lib.mkIf config.homelab.services.enable { };

  imports = [
    ./arr.nix
    ./audiobookshelf.nix
    ./deluge.nix
    ./homepage.nix
    ./jellyfin.nix
    ./syncthing.nix
  ];
}
