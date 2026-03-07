{ inputs, ... }:
{
  flake.modules.homeManager.desktop-tools = {
    imports = with inputs.self.modules.homeManager; [ ];
  };

  flake.modules.darwin.desktop-tools =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [ ];
      environment.systemPackages = with pkgs; [
      ];
    };

  flake.modules.nixos.desktop-tools =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [ ];
      environment.systemPackages = with pkgs; [
        unstable.rustdesk-flutter
        firefox-devedition
        signal-desktop
      ];
    };
}
