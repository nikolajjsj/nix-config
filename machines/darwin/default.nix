{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

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
    neovim
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
  security.pam.services.sudo_local.touchIdAuth = true;

  # Hack: issue with user ids and nix-darwin
  ids.gids.nixbld = 350;

  system.stateVersion = 4;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
