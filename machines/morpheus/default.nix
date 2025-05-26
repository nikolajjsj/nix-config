{ config, lib, pkgs, ... }:
let
  user = "neo";
  mediaUser = "multimedia";
in
{
  imports =
    [
      ./disko.nix
      ./hardware-configuration.nix
      ../../home/${user}/${user}.nix
      ../../homelab
    ];

  nixpkgs = {
    config.allowUnfree = true;
  };
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      allowed-users = [ user ];
      trusted-users = [
        "@admin"
        "root"
        user
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  networking = {
    hostId = "01823755";
    hostName = "morpheus";
  };
  time.timeZone = "Europe/Copenhagen";
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

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
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zroot/enc/local/root@blank
  '';

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
    ];
    users.${user} = {
      directories = [{ directory = ".ssh"; mode = "0700"; }];
      files = [ ];
    };
  };

  homelab = {
    services = {
      arr.enable = true;
      audiobookshelf.enable = true;
      deluge.enable = true;
      homepage.enable = true;
      jellyfin.enable = true;
      syncthing.enable = true;
    };
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
