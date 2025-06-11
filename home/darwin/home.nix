{ pkgs, ... }:
let
  user = "darwin";
in
{
  imports = [
    ../../modules/neovim
    ../../modules/tmux
    ../features/cli
  ];

  features = {
    cli = {
      zsh.enable = true;
      fzf.enable = true;
    };
  };

  home = {
    stateVersion = "24.11";
    username = "${user}";
    homeDirectory = "/Users/${user}";
    packages = with pkgs; [
      fd
      go
      gopls
      goose
      ripgrep
      nodejs
      lazygit
      pnpm
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
