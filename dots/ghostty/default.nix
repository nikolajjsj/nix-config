{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    settings = {
      font-size = 14;
    };

    themes = {
      tokyonight = {
        palette = [
          "0=#15161e"
          "1=#f7768e"
          "2=#9ece6a"
          "3=#e0af68"
          "4=#7aa2f7"
          "5=#bb9af7"
          "6=#7dcfff"
          "7=#a9b1d6"
          "8=#414868"
          "9=#ff899d"
          "10=#9fe044"
          "11=#faba4a"
          "12=#8db0ff"
          "13=#c7a9ff"
          "14=#a4daff"
          "15=#c0caf5"
        ];
        background = "#1a1b26";
        foreground = "#c0caf5";
        cursor-color = "#c0caf5";
        selection-background = "#283457";
        selection-foreground = "#c0caf5";
      };
    };
  };
}
