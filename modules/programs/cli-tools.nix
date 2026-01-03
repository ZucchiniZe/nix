let
  genericPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        fd
        git
        jujutsu
        neovim
        home-manager
      ];
    };
in
{
  flake.modules.darwin.cli-tools = {
    imports = [ genericPackages ];
  };

  flake.modules.nixos.cli-tools = {
    imports = [ genericPackages ];
  };

  flake.modules.homeManager.cli-tools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bat
        eza
        nh
        just
      ];
      programs.delta.enable = true;
      programs.delta.enableGitIntegration = true;
      programs.nh = {
        enable = true;
        flake = "/home/alex/nix";
        darwinFlake = "/Users/alex/Developer/01_nix";
      };
    };
}
