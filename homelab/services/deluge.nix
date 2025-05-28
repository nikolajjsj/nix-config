{ config, pkgs, lib, ... }:
let
  service = "deluge";
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
      default = "Deluge is a lightweight, Free Software, cross-platform BitTorrent client.";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "sh-${service}";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Downloads";
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
        { directory = "/var/lib/deluge"; user = "${cfg.user}"; group = "deluge"; }
      ];
    };

    services.deluge = {
      enable = true;
      web = {
        enable = true;
        openFirewall = true;
      };
      user = "${cfg.user}";
      openFirewall = true;
      declarative = true;
      config = {
        download_location = "/persist/downloads/incomplete";
        move_completed = true;
        move_completed_path = "/persist/downloads/completed";
        max_connections_global = 50;
        max_active_seeding = 0;
        max_active_downloading = 3;
        max_active_limit = 3;
        dont_count_slow_torrents = true;
        stop_seed_at_ratio = true;
        stop_seed_ratio = 0.00;
        share_ratio_limit = 0.00;
        new_release_check = false;
        enabled_plugins = [ "Label" ];
      };
      authFile = pkgs.writeTextFile {
        name = "deluge-auth";
        text = ''
          localclient:deluge:10
        '';
      };
    };
  };
}
