{ config, lib, ... }:
with lib;
let
  cfg = config.services.arr;
in
{
  options.services.arr = {
    enable = mkEnableOption "Enable Arr Stack.";
    user = mkOption {
      type = types.str;
      default = "multimedia";
      description = "User to run Arr services as.";
    };
  };

  config = mkIf cfg.enable {
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
  };
}
