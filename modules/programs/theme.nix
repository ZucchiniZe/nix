{ inputs, ... }:
{
  flake-file.inputs = {
    catppuccin.url = "github:catppuccin/nix";
  };
  flake.modules.homeManager.theme = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    catppuccin = {
      flavor = "frappe";
      alacritty.enable = true;
      bat.enable = true;
      eza.enable = true;
      helix.enable = true;
      nvim.enable = true;
      yazi.enable = true;
      zed.enable = true;
    };
  };
}
