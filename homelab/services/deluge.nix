{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homelab.services.deluge;
in
{
  options.homelab.services.deluge = {
    enable = mkEnableOption "Enable Deluge.";
    user = mkOption {
      type = types.str;
      default = "multimedia";
      description = "User to run Deluge as.";
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
        download_location = "/mnt/media/downloads/incomplete";
        move_completed = true;
        move_completed_path = "/mnt/media/downloads/completed";
        max_connections_global = 75;
        max_active_seeding = 3;
        max_active_downloading = 3;
        max_active_limit = 6;
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
