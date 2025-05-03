{ config, lib, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
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
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    git
    neovim
    vim
  ];

  # Services
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
