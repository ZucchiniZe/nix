{
  flake.modules.homeManager.terminal = {
    programs.alacritty = {
      enable = true;
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
