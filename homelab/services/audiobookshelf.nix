{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homelab.services.audiobookshelf;
in
{
  options.homelab.services.audiobookshelf = {
    enable = mkEnableOption "Enable Audiobookshelf.";
    user = mkOption {
      type = types.str;
      default = "multimedia";
      description = "User to run Audiobookshelf as.";
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
        { directory = "/var/lib/audiobookshelf"; user = "${cfg.user}"; group = "audiobookshelf"; }
      ];
    };

    services.audiobookshelf = {
      enable = true;
      user = "${cfg.user}";
      host = "0.0.0.0";
      port = 8113;
      openFirewall = true;
    };
  };
}
