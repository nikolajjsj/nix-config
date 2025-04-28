# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # ZFS stuff
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    mirroredBoots = [
      { devices = [ "/dev/disk/by-uuid/499E-F5C5" ]; path = "/boot-fallback"; }
    ];
  };

  networking.hostName = "morpheus";
  time.timeZone = "Europe/Copenhagen";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nikolaj = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    git
    figurine
    htop
    intel-gpu-tools
    powertop
    tmux
    rsync
    vim

    # Jellyfin
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # Services - Users
  users.groups.multimedia = { };

  # Services
  services.fstrim.enable = true;
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
  services.deluge = {
    user = "root";
    dataDir = "rust/downloads";
    web = {
      enable = true;
      openFirewall = true;
    };
    declarative = true;
    openFirewall = true;
    config = {
      enabled_plugins = [ "Label" ];
    };
  };
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.radarr = {
    enable = true;
    user = "root";
    openFirewall = true;
  };
  services.sonarr = {
    enable = true;
    user = "root";
    openFirewall = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 8112 ];
  networking.hostId = "01823755";

  # Intel QuickSync
  ## quicksync
  hardware.firmware = [ pkgs.linux-firmware ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
      intel-media-sdk # QSV up to 11th gen
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
