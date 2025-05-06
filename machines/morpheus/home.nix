{ user, ... }: { config, pkgs, lib, home-manager, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      imports = [
        ../../modules/neovim
        ../../modules/zsh
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
