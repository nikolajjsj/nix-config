{ config, pkgs, lib, ... }:
let
  service = "audiobookshelf";
  cfg = config.homelab.services.${service};
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "multimedia";
      description = "User to run ${service} as.";
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
      default = "Audiobookshelf is a self-hosted book/audiobook server.";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "sh-${service}";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
  };
  config = lib.mkIf cfg.enable {
    users.groups.${cfg.user} = { };
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = "${cfg.user}";
    };

    environment.persistence."/persist" = {
      directories = [
        { directory = "/var/lib/audiobookshelf"; user = "${cfg.user}"; group = "${service}"; }
      ];
    };

    services.${service} = {
      enable = true;
      user = "${cfg.user}";
      host = "0.0.0.0";
      port = 8113;
      openFirewall = true;
    };
  };
}
