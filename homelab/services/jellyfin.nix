{ config, pkgs, lib, ... }:
let
  service = "jellyfin";
  cfg = config.homelab.services.${service};
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.${homelab.baseDomain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Jellyfin";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "The Free Software Media System";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "sh-jellyfin";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
  };
  config = lib.mkIf cfg.enable {
    services.${service} = {
      enable = true;
      user = "${cfg.user}";
      openFirewall = true;
    };

    # Jellyfin persistence
    environment.persistence."/persist" = {
      directories = [
        { directory = "/var/lib/jellyfin"; user = "${cfg.user}"; group = "jellyfin"; }
      ];
    };

    # Jellyfin hardware acceleration
    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
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
