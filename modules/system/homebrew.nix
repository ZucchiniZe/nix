{
  flake.modules.darwin.homebrew = {
    homebrew = {
      enable = true;
      enableZshIntegration = true;
      brews = [ "telnet" ];
      casks = [
        "raycast"
        "publii"
        "ghostty"
        "touchdesigner"
      ];
    };
  };
}
