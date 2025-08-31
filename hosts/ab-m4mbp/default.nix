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
    ./system.nix
    inputs.home-manager.darwinModules.home-manager
    {
      users.users.alex.home = /Users/alex;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${user} = ../../home.nix;
      };
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

  homebrew = {
    enable = true;
    casks = [
      "raycast"
      "publii"
    ];
  };

  system = {
    primaryUser = user;
    # initial version for setting backwards incompatibility
    stateVersion = 6;
  };
}
