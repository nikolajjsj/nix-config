# My Nix configuration

## Commands
```bash
# Update NixOS
nixos-rebuild switch --flake .
```
```bash
# Update Nix-Darwin
nix run nix-darwin -- switch --flake .
```
```bash
# Run Disko 
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /**/disko.nix
```
