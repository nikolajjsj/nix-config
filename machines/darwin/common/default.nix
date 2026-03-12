{ ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    settings = {
      max-jobs = "auto";
      trusted-users = [
        "root"
        "neo"
        "@admin"
      ];
    };
  };
}

