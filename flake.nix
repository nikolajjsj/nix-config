{
  description = "My homelab configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      morpheus = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./machines/morpheus/default.nix ];
      };
    };
  };
}
