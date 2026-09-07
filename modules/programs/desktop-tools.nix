{ inputs, ... }:
{
  flake-file.inputs = {
    negpy.url = "github:marcinz606/NegPy";
    negpy.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.desktop-tools = {
    imports = with inputs.self.modules.homeManager; [ ];
  };

  flake.modules.darwin.desktop-tools =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [ ];
      environment.systemPackages = with pkgs; [
      	blender
      ];
    };

  flake.modules.nixos.desktop-tools =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [ ];
      environment.systemPackages =
        with pkgs;
        [
          baobab
          blender
          unstable.rustdesk-flutter
          firefox-devedition
          signal-desktop
          kdePackages.partitionmanager
          obsidian
        ]
        ++ [ inputs.negpy.packages.x86_64-linux.default ];

      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    };
}
