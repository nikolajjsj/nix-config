{ config, pkgs, inputs, ... }:
let
  user = "darwin";
in
{
  imports = [
    ../common
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isNormalUser = true;
    isHidden = false;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    ignoreShellProgramCheck = true;
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  };

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.${user} = (import ./home.nix { user = user; });
  };
}
