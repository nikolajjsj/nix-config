{
  description = "My homelab configurations";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      lib = nixpkgs.lib;
    in
    {
      darwinConfigurations = {
        darwin = inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./machines/darwin/default.nix
          ];
        };
      };
      nixosConfigurations = {
        morpheus = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./machines/morpheus/default.nix ];
        };
      };
    };
}
