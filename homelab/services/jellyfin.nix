{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homelab.services.jellyfin;
in
{
  options.homelab.services.jellyfin = {
    enable = mkEnableOption "Enable Jellyfin.";
    user = mkOption {
      type = types.str;
      default = "multimedia";
      description = "User to run Jellyfin as.";
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
        { directory = "/var/lib/jellyfin"; user = "${cfg.user}"; group = "jellyfin"; }
      ];
    };

    services.jellyfin = {
      enable = true;
      user = "${cfg.user}";
      openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];

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
  };
}
