{ config, lib, ... }:
with lib;
let
  cfg = config.homelab.services.syncthing;
in
{
  options.homelab.services.syncthing.enable = mkEnableOption "Enable Syncthing.";

  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      directories = [
        { directory = "/var/lib/syncthing"; user = "syncthing"; group = "syncthing"; }
      ];
    };

    services.syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
    };
    networking.firewall.allowedTCPPorts = [ 8384 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  };
}
