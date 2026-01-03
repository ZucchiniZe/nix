{
  flake.modules.darwin.homebrew = {
    homebrew = {
      enable = true;
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
