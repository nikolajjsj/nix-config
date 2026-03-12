{
  inputs,
  lib,
  config,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Nikolaj";
        email = "10490273+nikolajjsj@users.noreply.github.com";
      };
    };
  };
}

