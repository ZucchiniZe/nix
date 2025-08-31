{
  pkgs,
  inputs,
  ...
}:
let
  user = "alex";
  weekly = {
    Weekday = 6;
  };
in
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = ./home.nix;
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
    deploy-rs
  ];

  system = {
    primaryUser = user;
    # initial version for setting backwards incompatibility
    stateVersion = 6;
  };
}
