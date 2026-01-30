{
  flake.modules.nixos.web-tools =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ firefox-devedition ];
    };
}
