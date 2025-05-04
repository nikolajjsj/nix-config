{ config, lib, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/zsh/default.nix
    ];

  # ZFS stuff
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    forceImportRoot = true;
    extraPools = [ "rust" ];
  };
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot"; }
      { devices = [ "nodev" ]; path = "/boot-fallback"; }
    ];
  };

  networking.hostId = "01823755";
  networking.hostName = "morpheus";
  time.timeZone = "Europe/Copenhagen";

  # Define a user account. Don't forget to set a password with passwd.
  users.users.nikolaj = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0dkeI+7IdQujtZ3UCSfYB2uPFKZz3i7hWlO4O/sMh+ me@nikolajjsj.com"
    ];
  };
  # Define a 'media' user account.
  users.users.multimedia = {
    isNormalUser = true;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    btop
    eza
    git
    neovim
    vim
    intel-gpu-tools
    # Jellyfin
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
    openDefaultPorts = true;
  };
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    openFirewall = true;
    mediaLocation = "/mnt/photos";
  };
  services.jellyfin = {
    enable = true;
    user = "multimedia";
    openFirewall = true;
  };
  services.deluge = {
    enable = true;
    web = {
      enable = true;
      openFirewall = true;
    };
    user = "multimedia";
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
    user = "multimedia";
    openFirewall = true;
  };
  services.sonarr = {
    enable = true;
    user = "multimedia";
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

  system.stateVersion = "24.11"; # Did you read the comment?

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };
}
