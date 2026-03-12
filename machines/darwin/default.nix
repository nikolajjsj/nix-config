{lib, self, ...}:
let
  user = "neo";
  entries = builtins.attrNames (builtins.readDir ./.);
  configs = builtins.filter (dir: builtins.pathExists (./. + "/${dir}/configuration.nix")) entries;
  homeManagerCfg = userPackages: {
    home-manager.useGlobalPkgs = false;
    home-manager.extraSpecialArgs = {
      inherit (self) inputs;
    };
    home-manager.users.${user}.imports = [
      self.inputs.agenix.homeManagerModules.default
      self.inputs.nix-index-database.homeModules.nix-index
      ../../users/${user}/dots.nix
      ../../users/${user}/age.nix
      ../../dots/tmux
      ../../dots/ghostty
      ../../dots/neovim
      ../../dots/zsh
    ];
    home-manager.backupFileExtension = "bak";
    home-manager.useUserPackages = userPackages;
  };
in
{
  flake.darwinConfigurations = lib.listToAttrs (
    builtins.map (
      name:
      lib.nameValuePair name (
        self.inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit (self) inputs;
            self = {
              darwinModules = self.darwinModules;
            };
          };

          modules = [
            self.inputs.agenix.darwinModules.default
            self.inputs.home-manager.darwinModules.home-manager
            (./. + "/common/default.nix")
            (./. + "/${name}/configuration.nix")
            (self.inputs.nixpkgs.lib.attrsets.recursiveUpdate (homeManagerCfg true) {
              home-manager.users.${user}.home.homeDirectory =
                self.inputs.nixpkgs.lib.mkForce "/Users/${user}";
            })
          ];
        }
      )
    ) configs
  );
}

