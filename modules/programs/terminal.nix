{
  flake.modules.nixos.terminal =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        alacritty
        fuzzel
      ];
    };
}
