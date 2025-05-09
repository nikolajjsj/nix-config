{ user, ... }: { config, pkgs, lib, home-manager, ... }:
{
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # Services
  services.openssh = {
    enable = true;
    openFirewall = true;
  };
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    allowedHosts = "192.168.20.100:8082";
    services = [
      {
        "Arr" = [
          {
            "Prowlarr" = {
              href = "http://192.168.20.100:9696";
            };
          }
          {
            "Radarr" = {
              href = "http://192.168.20.100:7878";
            };
          }
          {
            "Sonarr" = {
              href = "http://192.168.20.100:8989";
            };
          }
          {
            "Bazarr" = {
              href = "http://192.168.20.100:6767";
            };
          }
        ];
      }
      {
        "Media" = [
          {
            "Jellyfin" = {
              href = "http://192.168.20.100:8096";
            };
          }
        ];
      }
      {
        "Downloads" = [
          {
            "Deluge" = {
              href = "http://192.168.20.100:8112";
            };
          }
        ];
      }
      {
        "Services" = [
          {
            "Syncthing" = {
              href = "http://192.168.20.100:8384";
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
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
  };
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  services.jellyfin = {
    enable = true;
    user = "${user}";
    openFirewall = true;
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
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.radarr = {
    enable = true;
    user = "${user}";
    openFirewall = true;
  };
  services.sonarr = {
    enable = true;
    user = "${user}";
    openFirewall = true;
  };
  services.bazarr = {
    enable = true;
    user = "${user}";
    openFirewall = true;
  };

  # Jellyfin hardware acceleration
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
      libva-vdpau-driver # Previously vaapiVdpau
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
    ];
  };
}
