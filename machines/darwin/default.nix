{ config, lib, pkgs, ... }:
{
  networking.hostName = "darwin";
  time.timeZone = "Europe/Copenhagen";

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
    casks = [
      "google-chrome"
      "tailscale"
      "zen-browser"
    ];
    brews = [ ];
  };
  environment.systemPackages = with pkgs; [
    go
    eza
    neofetch
    tmux
    rsync
    ripgrep
    slack
  ];

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowStatusBar = true;
    };
  };
  # Enable touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
