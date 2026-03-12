{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  system.stateVersion = "25.11";

  systemd.services.nixos-upgrade.preStart = ''
    cd /etc/nixos
    chown -R root:root .
    git reset --hard HEAD
    git pull
  '';

  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos#${config.networking.hostName}";
    flags = [
      "-L"
      "--accept-flake-config"
    ];
    dates = "Sat *-*-* 02:30:00";
    allowReboot = true;
  };

  imports = [
    ./filesystems
    ./nix
  ];

  time.timeZone = "Europe/Copenhagen";

  users.users = {
    nikolaj = {
      hashedPasswordFile = config.age.secrets.hashedUserPassword.path;
    };
    root = {
      initialHashedPassword = config.age.secrets.hashedUserPassword.path;
    };
  };

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PasswordAuthentication = lib.mkDefault false;
      LoginGraceTime = 0;
      PermitRootLogin = "no";
    };
    ports = [ 69 ];
    hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  programs.git.enable = true;
  programs.mosh.enable = true;
  programs.htop.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  age = {
    identityPaths = [
      "/persist/ssh/ssh_host_ed25519_key"
    ];
    secrets = {
      hashedUserPassword.file = "../../../secrets/hashed-user-password.age";
      smtpPassword = {
        file = "../../../secrets/smtp-password.age";
        owner = "nikolaj";
        group = "nikolaj";
        mode = "0440";
      };
    };

  };
  email = {
    enable = true;
    fromAddress = "nikolajjsj@gmail.com";
    toAddress = "me@nikolajjsj.com";
    smtpServer = "smtp.gmail.com";
    smtpUsername = "nikolajjsj@gmail.com";
    smtpPasswordPath = config.age.secrets.smtpPassword.path;
  };

  security = {
    doas.enable = lib.mkDefault false;
    sudo = {
      enable = lib.mkDefault true;
      wheelNeedsPassword = lib.mkDefault false;
    };
  };

  homelab.motd.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    iperf3
    eza
    fastfetch
    tmux
    rsync
    iotop
    ripgrep
    lm_sensors
  ];
}

