{ config, lib, ... }:
with lib;
let
  cfg = config.homelab.services.homepage;
in
{
  options.homelab.services.homepage = {
    enable = mkEnableOption "Enable Homepage Dashboard.";
    ip = mkOption {
      type = types.str;
      default = "192.168.20.100";
      description = "IP address for homepage dashboard.";
    };
  };

  config = mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "${cfg.ip}:8082";
      services = [
        {
          "Arr" = [
            {
              "Prowlarr" = {
                href = "http://${cfg.ip}:9696";
                icon = "sh-prowlarr";
              };
            }
            {
              "Radarr" = {
                href = "http://${cfg.ip}:7878";
                icon = "sh-radarr";
              };
            }
            {
              "Sonarr" = {
                href = "http://${cfg.ip}:8989";
                icon = "sh-sonarr";
              };
            }
            {
              "Bazarr" = {
                href = "http://${cfg.ip}:6767";
                icon = "sh-bazarr";
              };
            }
            {
              "Readarr" = {
                href = "http://${cfg.ip}:8787";
                icon = "sh-readarr";
              };
            }
          ];
        }
        {
          "Media" = [
            {
              "Jellyfin" = {
                href = "http://${cfg.ip}:8096";
                icon = "sh-jellyfin";
              };
            }
          ];
        }
        {
          "Downloads" = [
            {
              "Deluge" = {
                href = "http://${cfg.ip}:8112";
                icon = "sh-deluge";
              };
            }
          ];
        }
        {
          "Services" = [
            {
              "Syncthing" = {
                href = "http://${cfg.ip}:8384";
                icon = "sh-syncthing";
              };
            }
          ];
        }
      ];
      settings = {
        layout = [
          {
            Glances = {
              header = false;
              style = "row";
              columns = 4;
            };
          }
          {
            Arr = {
              header = true;
              style = "column";
            };
          }
          {
            Media = {
              header = true;
              style = "column";
            };
          }
          {
            Downloads = {
              header = true;
              style = "column";
            };
          }
          {
            Services = {
              header = true;
              style = "column";
            };
          }
        ];
        headerStyle = "clean";
        statusStyle = "dot";
        hideVersion = "true";
      };
      customCSS = ''
        body, html {
          font-family: SF Pro Display, Helvetica, Arial, sans-serif !important;
        }
        .font-medium {
          font-weight: 700 !important;
        }
        .font-light {
          font-weight: 500 !important;
        }
        .font-thin {
          font-weight: 400 !important;
        }
        #information-widgets {
          padding-left: 1.5rem;
          padding-right: 1.5rem;
        }
        div#footer {
          display: none;
        }
        .services-group.basis-full.flex-1.px-1.-my-1 {
          padding-bottom: 3rem;
        };
      '';
    };
  };
}

