{ config, pkgs, inputs, ... }:
let
  user = "neo";
in
{
  imports = [
    ../common
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0dkeI+7IdQujtZ3UCSfYB2uPFKZz3i7hWlO4O/sMh+ me@nikolajjsj.com"
    ];
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  };

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.${user} = import ./home.nix;
  };
}
