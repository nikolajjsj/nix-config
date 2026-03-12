{
  pkgs,
  lib,
  ...
}:
{
  programs.neovim = {
    enable = true;
  };

  xdg.configFile."nvim".source = ../../legacy/nvim;
}
