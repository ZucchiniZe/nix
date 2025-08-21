{
  pkgs,
  ...
}:
let
  user = "alex";
in
{
  imports = [ ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
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
}
