{ config, lib, pkgs, ... }:
{
  # For using nix-darwin together with Determinate-Nix
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  users.users.darwin.home = "/Users/darwin";

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
      "dbngin"
      "docker"
      "google-chrome"
      "tailscale"
      "zen-browser"
      "ghostty"
      "syncthing"
    ];
    brews = [ "nvm" ];
  };
  environment.systemPackages = with pkgs; [
    go
    gopls
    goose
    eza
    fd
    lazygit
    neofetch
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
  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 4;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
