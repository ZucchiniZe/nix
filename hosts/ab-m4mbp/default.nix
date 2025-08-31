{
  pkgs,
  lib,
  home-manager,
  ...
}:
let
  user = "alex";
  home = "/Users/${user}";
  weekly = {
    Weekday = 6;
  };
in
{
  imports = [
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = ../../home.nix;
      home-manager.homeDirectory = lib.mkForce home;
    }
  ];

  nix = {
    gc = {
      automatic = true;
      interval = weekly;
    };
    optimise = {
      automatic = true;
      interval = weekly;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [
    nixfmt
    nil
    just
    utm
  ];

  system = {
    primaryUser = user;
    # initial version for setting backwards incompatibility
    stateVersion = 6;
  };
}
