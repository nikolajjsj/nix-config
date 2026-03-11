{
  description = "My Homelab configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, disko, impermanence, nixpkgs }:
    let
      lib = nixpkgs.lib;
      darwinSystem = "aarch64-darwin";
      nixosSystem = "x86_64-linux";
    in
    {
      nixpkgs.config.allowUnfree = true;

      darwinConfigurations = {
        darwin = inputs.nix-darwin.lib.darwinSystem {
          system = darwinSystem;
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
        neo = lib.nixosSystem {
          system = nixosSystem;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./machines/neo/default.nix
            home-manager.nixosModules.home-manager
            impermanence.nixosModules.impermanence
          ];
        };
      };
    };
}
