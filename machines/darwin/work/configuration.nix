{inputs, pkgs, ...}:
{
  nix.enable = false;
  
  system.primaryUser = "neo";

  imports = [
    ./secrets.nix
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    brewPrefix = "/opt/homebrew/bin";
    casks = [
      "ghostty"
      "google-chrome"
      "slack"
      "netbird-ui"
      "obsidian"
      "proton-drive"
      "proton-pass"
    ];
    taps = [];
    brews = [];
    masApps = {
      "amphetamine" = 937984704;
      "wireguard" = 1451685025;
    };
  };
  environment.systemPackages = with pkgs; [
    fnm
    eza
    neofetch
    tmux
    rsync
    ripgrep
    lazygit
    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 5;
    defaults = {
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      finder = {
        FXDefaultSearchScope = "SCcf";
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        ShowStatusBar = true;
      };
      dock = {
        # Quick Note on the bottom right hot corner
        wvous-br-corner = 14;
        tilesize = 50;
      };
      NSGlobalDomain = {
        "com.apple.sound.beep.volume" = 0.0;
        InitialKeyRepeat = 13;
        KeyRepeat = 2;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    # TODO: Figure out how to do this
    # activationScripts.postUserActivation.text = ''
    #   # Following line should allow us to avoid a logout/login cycle
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    #   launchctl stop com.apple.Dock.agent
    #   launchctl start com.apple.Dock.agent
    # '';
  };
}
