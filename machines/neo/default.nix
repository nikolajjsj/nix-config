{ config, lib, pkgs, ... }:
let
  user = "neo";
in
{
  imports =
    [
      ./hardware-configuration.nix
      ../../home/${user}
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
    hostName = user;
  };
  time.timeZone = "Europe/Copenhagen";
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  homelab = {
    enable = true;
    baseDomain = "nikolajjsj.com";

    services = {
      enable = true;

      uptime-kuma = {
        enable = true;
      };
    };
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
