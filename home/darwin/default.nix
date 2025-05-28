{ pkgs, inputs, ... }:
let
  user = "darwin";
in
{
  imports = [
    ../common
    inputs.home-manager.darwinModules.home-manager
  ];

  nix.enable = false;

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  };

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.${user} = (import ./home.nix { inherit pkgs inputs; user = user; });
  };
}
