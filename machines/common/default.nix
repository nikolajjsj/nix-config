{ user, ... }: { lib, inputs, outputs, ... }:
{
  nixpkgs = {
    #overlays = [
    # Add overlays your own flake exports (from overlays and pkgs dir):
    # outputs.overlays.additions
    # outputs.overlays.modifications
    # outputs.overlays.stable-packages

    # You can also add overlays exported from other flakes:
    # neovim-nightly-overlay.overlays.default

    # Or define it inline, for example:
    # (final: prev: {
    #   hi = final.hello.overrideAttrs (oldAttrs: {
    #     patches = [ ./change-hello-to-hi.patch ];
    #   });
    # })
    #];
    config = {
      allowUnfree = true;
    };
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

  environment.systemPackages = with pkgs; [
    btop
    fd
    git
    lazygit
  ];
}

