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
        backupFileExtension = "pre-hm";
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
    nixd
    just
    utm
    deploy-rs
  ];

  homebrew = {
    enable = true;
    casks = [
      "raycast"
      "publii"
      "ghostty"
    ];
  };

  # allow ssh into laptop
  services.openssh.enable = true;

  system = {
    primaryUser = user;
    # initial version for setting backwards incompatibility
    stateVersion = 6;
  };
}
