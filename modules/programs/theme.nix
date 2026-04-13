{ inputs, ... }:
{
  flake-file.inputs = {
    catppuccin.url = "github:catppuccin/nix/v25.11";
  };

  flake.modules.homeManager.theme = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    catppuccin = {
      flavor = "frappe";
      alacritty.enable = true;
      bat.enable = true;
      delta.enable = true;
      eza.enable = true;
      helix.enable = true;
      nvim.enable = true;
      yazi.enable = true;
      zed.enable = true;
    };
  };
}
