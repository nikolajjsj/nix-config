{ config, lib, pkgs, home-manager, ... }:
let
  user = "darwin";
in
{
  imports = [
    ../../home/${user}
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    brewPrefix = "/opt/homebrew/bin";
    caskArgs = {
      no_quarantine = true;
    };
    brews = [ ];
    casks = [
      "dbngin"
      "docker"
      "ghostty"
      "google-chrome"
      "slack"
      "syncthing"
      "tableplus"
      "tailscale"
    ];
    masApps = {
      "amphetamine" = 937984704;
      "wireguard" = 1451685025;
    };
  };

  system = {
    stateVersion = 4;

    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        mru-spaces = false;
        show-recents = false;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        AppleShowAllExtensions = true;
        ShowStatusBar = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  # Enable touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
