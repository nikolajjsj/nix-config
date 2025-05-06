{
  description = "My homelab configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }:
    let
      lib = nixpkgs.lib;
    in
    {
      # General configurations
      nixpkgs.config.allowUnfree = true;

      # System specific configurations
      darwinConfigurations = {
        darwin = inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./machines/darwin/default.nix
            home-manager.darwinModules.home-manager
          ];
        };
      };
      nixosConfigurations = {
        morpheus = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./machines/morpheus/default.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
