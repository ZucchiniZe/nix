{
  flake.modules.homeManager.terminal =
    { pkgs, ... }:
    {
      programs.alacritty = {
        # since homemanager is both darwin and linux
        enable = pkgs.stdenv.isLinux;
        theme = "catppuccin_frappe";
        settings = {
          window.decorations = "None";
          font.normal = {
            family = "Liga SFMono Nerd Font";
          };
        };
      };
    };
}
