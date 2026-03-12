{
  lib,
  self,
  ...
}:
let
  user = "nikolaj";
  entries = builtins.attrNames (builtins.readDir ./.);
  configs = builtins.filter (dir: builtins.pathExists (./. + "/${dir}/configuration.nix")) entries;
  homeManagerCfg = userPackages: extraImports: {
    home-manager.useGlobalPkgs = false;
    home-manager.extraSpecialArgs = {
      inherit (self) inputs;
    };
    home-manager.users.${user}.imports = [
      self.inputs.agenix.homeManagerModules.default
      self.inputs.nix-index-database.homeModules.nix-index
      self.inputs.lazyvim.homeModules.nixvim
      ../../users/${user}/dots.nix
      ../../users/${user}/age.nix
      ../../dots/tmux
      ../../dots/nvim
    ]
    ++ extraImports;
    home-manager.backupFileExtension = "bak";
    home-manager.useUserPackages = userPackages;
  };
in
{

  flake.nixosConfigurations =
    let
      nixpkgsMap = {
        maya = "-unstable";
      };
      systemArchMap = {
        mona = "aarch64-linux";
      };
      myNixosSystem =
        name: self.inputs."nixpkgs${lib.attrsets.attrByPath [ name ] "" nixpkgsMap}".lib.nixosSystem;
    in
    lib.listToAttrs (
      builtins.map (
        name:
        lib.nameValuePair name (
          (myNixosSystem name) {
            system = lib.attrsets.attrByPath [ name ] "x86_64-linux" systemArchMap;
            specialArgs = {
              inherit (self) inputs;
              self = {
                nixosModules = self.nixosModules;
              };
            };

            modules = [
              ../../homelab
              self.inputs.agenix.nixosModules.default
              self.inputs."home-manager${
                lib.attrsets.attrByPath [ name ] "" nixpkgsMap
              }".nixosModules.home-manager
              (./. + "/common/default.nix")
              (./. + "/${name}/configuration.nix")
              ../../users/${user}
              (homeManagerCfg false [ ])
            ];
          }
        )
      ) configs
    );
}

