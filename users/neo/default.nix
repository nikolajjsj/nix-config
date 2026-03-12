{
  pkgs,
  ...
}:
{
  nix.settings.trusted-users = [ "neo" ];

  users = {
    users = {
      neo = {
        shell = pkgs.zsh;
        uid = 1000;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "users"
          "video"
          "podman"
          "input"
        ];
        group = "neo";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0dkeI+7IdQujtZ3UCSfYB2uPFKZz3i7hWlO4O/sMh+ me@nikolajjsj.com"
        ];
      };
    };
    groups = {
      neo = {
        gid = 1000;
      };
    };
  };
  programs.zsh.enable = true;
}

