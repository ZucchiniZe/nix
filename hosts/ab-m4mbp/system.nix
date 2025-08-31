{
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults = {
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    finder = {
      ShowStatusBar = true;
      ShowPathbar = true;
      NewWindowTarget = "Home";
      AppleShowAllExtensions = true;
    };
    dock = {
      # hot corners
      wvous-tr-corner = 2; # top right mission control
      wvous-br-corner = 5; # bottom right start screensaver
      wvous-bl-corner = 10; # bottom left sleep display

      autohide = true;
      orientation = "left";
    };
  };
}
