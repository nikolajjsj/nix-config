{ config, lib, ... }:
with lib;
let
  cfg = config.features.cli.fzf;
in
{
  options.features.cli.fzf.enable = mkEnableOption "Enable fzf shell integration.";

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
