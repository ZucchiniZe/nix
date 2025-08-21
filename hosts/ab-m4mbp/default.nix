{
  pkgs,
  ...
}:
let
  user = "alex";
  weekly = {
    Weekday = 6;
  };
in
{
  imports = [ ];

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
    utm
  ];

  system = {
    primaryUser = user;
  };

  # initial version for setting backwards incompatibility
  system.stateVersion = 6;
}
