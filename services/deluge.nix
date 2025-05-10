{ config, lib, ... }:
with lib;
let
  cfg = config.services.deluge;
in
{
  options.services.deluge = {
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
      user = "${user}";
      dataDir = "/mnt/media/downloads";
      openFirewall = true;
      declarative = true;
      config = {
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
