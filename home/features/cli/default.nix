{ pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./fzf.nix
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
  };
}
