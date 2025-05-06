{ config, lib, pkgs, ... }:
let user = "nikolaj"; in
{
  imports =
    [
      ./hardware-configuration.nix
      ./services.nix
      (import ./home.nix { user = user; })
    ];

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

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0dkeI+7IdQujtZ3UCSfYB2uPFKZz3i7hWlO4O/sMh+ me@nikolajjsj.com"
    ];
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

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    btop
    eza
    git
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
