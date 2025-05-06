{ user, ... }: { config, pkgs, lib, home-manager, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      imports = [
        ../../modules/neovim
        ../../modules/zsh
      ];

      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0dkeI+7IdQujtZ3UCSfYB2uPFKZz3i7hWlO4O/sMh+ me@nikolajjsj.com"
      ];

      home = {
        stateVersion = "24.11";

        username = "${user}";
        homeDirectory = "/home/${user}";
        packages = [ ];
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };
}
