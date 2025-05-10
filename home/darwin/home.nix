{ user, ... }: { config, lib, pkgs, ... }:
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
      go
      gopls
      goose
      ripgrep
      nodejs
      pnpm
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
