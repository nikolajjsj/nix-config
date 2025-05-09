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
      (import ./services.nix { user = mediaUser; })
      (import ./home.nix { user = user; })
    ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0dkeI+7IdQujtZ3UCSfYB2uPFKZz3i7hWlO4O/sMh+ me@nikolajjsj.com"
    ];
  };
  users.groups.${mediaUser} = { };
  users.users.${mediaUser} = {
    isSystemUser = true;
    group = "multimedia";
  };

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      { directory = "/var/lib/syncthing"; user = "syncthing"; group = "syncthing"; }
      { directory = "/var/lib/jellyfin"; user = "${mediaUser}"; group = "jellyfin"; }
      { directory = "/var/lib/prowlarr"; user = "${mediaUser}"; group = "prowlarr"; }
      { directory = "/var/lib/radarr"; user = "${mediaUser}"; group = "radarr"; }
      { directory = "/var/lib/sonarr"; user = "${mediaUser}"; group = "sonarr"; }
      { directory = "/var/lib/bazarr"; user = "${mediaUser}"; group = "bazarr"; }
      { directory = "/var/lib/deluge"; user = "${mediaUser}"; group = "deluge"; }
    ];
    users.${user} = {
      directories = [{ directory = ".ssh"; mode = "0700"; }];
      files = [ ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      allowed-users = [ "${user}" ];
      trusted-users = [ "@admin" "${user}" ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.hostId = "01823755";
  networking.hostName = "morpheus";
  time.timeZone = "Europe/Copenhagen";

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

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    btop
    eza
    git
  ];

  fileSystems."/persist".neededForBoot = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
