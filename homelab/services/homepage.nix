{ config, lib, ... }:
with lib;
let
  service = "homepage";
  cfg = config.homelab.services.${service};
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = mkEnableOption "Enable ${service}.";
    ip = mkOption {
      type = types.str;
      default = "192.168.20.100";
      description = "IP address for ${service}.";
    };
    port = mkOption {
      type = types.str;
      default = "8082";
      description = "Port for ${service}.";
    };
  };

  config = mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "${cfg.ip}:${cfg.port}";
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
      services = [
        {
          "Arr" = [
            {
              "Prowlarr" = {
                href = "http://${cfg.ip}:9696";
                siteMonitor = "http://${cfg.ip}:9696";
                icon = "sh-prowlarr";
                description = "PVR indexer";
              };
            }
            {
              "Radarr" = {
                href = "http://${cfg.ip}:7878";
                siteMonitor = "http://${cfg.ip}:7878";
                icon = "sh-radarr";
                description = "Movie collection manager";
              };
            }
            {
              "Sonarr" = {
                href = "http://${cfg.ip}:8989";
                siteMonitor = "http://${cfg.ip}:8989";
                icon = "sh-sonarr";
                description = "TV collection manager";
              };
            }
            {
              "Bazarr" = {
                href = "http://${cfg.ip}:6767";
                siteMonitor = "http://${cfg.ip}:6767";
                icon = "sh-bazarr";
                description = "Subtitles manager";
              };
            }
          ];
        }
        {
          "Media" = [
            {
              "Jellyfin" = {
                href = "http://${cfg.ip}:8096";
                siteMonitor = "http://${cfg.ip}:8096";
                icon = "sh-jellyfin";
                description = "The free software media system";
              };
            }
            {
              "Audiobookshelf" = {
                href = "http://${cfg.ip}:8113";
                siteMonitor = "http://${cfg.ip}:8113";
                icon = "sh-audiobookshelf";
                description = "The free software audiobooks system";
              };
            }
          ];
        }
        {
          "Downloads" = [
            {
              "Deluge" = {
                href = "http://${cfg.ip}:8112";
                siteMonitor = "http://${cfg.ip}:8112";
                icon = "sh-deluge";
                description = "Torrent client";
              };
            }
          ];
        }
        {
          "Services" = [
            {
              "Syncthing" = {
                href = "http://${cfg.ip}:8384";
                siteMonitor = "http://${cfg.ip}:8384";
                icon = "sh-syncthing";
                description = "File synchronization";
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
    };
  };
}

