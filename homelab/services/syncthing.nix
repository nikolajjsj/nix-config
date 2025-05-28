{ config, pkgs, lib, ... }:
let
  service = "syncthing";
  cfg = config.homelab.services.${service};
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "${service}.${homelab.baseDomain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "${lib.capitalize service}";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Syncthing is a continuous file synchronization program.";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "sh-${service}";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      directories = [
        { directory = "/var/lib/${service}"; user = "${service}"; group = "${service}"; }
      ];
    };

    services.${service} = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
    };
    networking.firewall.allowedTCPPorts = [ 8384 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  };
}
