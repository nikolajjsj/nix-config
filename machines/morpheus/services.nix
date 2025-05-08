{ config, pkgs, lib, home-manager, ... }:
let mediaUser = "multimedia"; in
{
  # Define a 'media' user account.
  users.users.${mediaUser} = {
    isNormalUser = true;
  };

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
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
  };
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  services.jellyfin = {
    enable = true;
    user = "${mediaUser}";
    openFirewall = true;
  };
  services.deluge = {
    enable = true;
    web = {
      enable = true;
      openFirewall = true;
    };
    user = "${mediaUser}";
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
    user = "${mediaUser}";
    openFirewall = true;
  };
  services.sonarr = {
    enable = true;
    user = "${mediaUser}";
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
