{ config, lib, ... }:
with lib;
let
  service = "vaultwarden";
  cfg = config.homelab.services.${service};
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = mkEnableOption "Enable ${service}";
    configDir = mkOption {
      type = types.str;
      default = "/var/lib/bitwarden_rs";
    };
    url = mkOption {
      type = types.str;
      default = "pass.${config.homelab.baseDomain}";
    };
    homepage.name = mkOption {
      type = types.str;
      default = "${lib.capitalize service}";
    };
    homepage.description = mkOption {
      type = types.str;
      default = "Password manager";
    };
    homepage.icon = mkOption {
      type = types.str;
      default = "sh-bitwarden";
    };
    homepage.category = mkOption {
      type = types.str;
      default = "Services";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      directories = [
        { directory = "/var/lib/${service}"; user = "${service}"; group = "${service}"; }
      ];
    };

    services = {
      ${service} = {
        enable = true;
        config = {
          DOMAIN = "https://${cfg.url}";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          EXTENDED_LOGGING = true;
          LOG_LEVEL = "warn";
          IP_HEADER = "CF-Connecting-IP";
        };
      };
    };
  };
}
