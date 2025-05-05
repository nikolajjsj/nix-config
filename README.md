# My Nix configuration

## Commands
```bash
# Update NixOS
sudo nixos-rebuild switch --flake .
```
```bash
# Update Nix-Darwin
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .
```
