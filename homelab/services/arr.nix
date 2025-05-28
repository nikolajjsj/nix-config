{ config, pkgs, lib, ... }:
let
  service = "arr";
  cfg = config.homelab.services.${service};
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
    user = mkOption {
      type = types.str;
      default = "multimedia";
      description = "User to run ${service} as.";
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
        { directory = "/var/lib/prowlarr"; user = "${cfg.user}"; group = "prowlarr"; }
        { directory = "/var/lib/radarr"; user = "${cfg.user}"; group = "radarr"; }
        { directory = "/var/lib/sonarr"; user = "${cfg.user}"; group = "sonarr"; }
        { directory = "/var/lib/bazarr"; user = "${cfg.user}"; group = "bazarr"; }
        { directory = "/var/lib/readarr"; user = "${cfg.user}"; group = "readarr"; }
      ];
    };

    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };
    services.radarr = {
      enable = true;
      user = "${cfg.user}";
      openFirewall = true;
    };
    services.sonarr = {
      enable = true;
      user = "${cfg.user}";
      openFirewall = true;
    };
    services.bazarr = {
      enable = true;
      user = "${cfg.user}";
      openFirewall = true;
    };
    services.readarr = {
      enable = false;
      user = "${cfg.user}";
      openFirewall = true;
    };
  };
}
