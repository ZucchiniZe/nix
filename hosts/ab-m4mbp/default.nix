{
  pkgs,
  inputs,
  gitRevision,
  ...
}:
let
  user = "alex";
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

  # Determinite Nix needs to take over from nix-darwin apparently
  nix.enable = false;
  # nix = {
  #   gc = {
  #     automatic = true;
  #     interval = weekly;
  #   };
  #   optimise = {
  #     automatic = true;
  #     interval = weekly;
  #   };
  #   extraOptions = ''
  #     experimental-features = nix-command flakes
  #   '';
  # };

  system.configurationRevision = gitRevision;

  environment.systemPackages = with pkgs; [
    nixfmt
    nixd
    utm
    imhex
    hexfiend
    deploy-rs
    uv
  ];

  homebrew = {
    enable = true;
    brews = [
      "telnet"
    ];
    casks = [
      "raycast"
      "publii"
      "ghostty"
      "touchdesigner"
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
