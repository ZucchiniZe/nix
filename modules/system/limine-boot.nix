{
  flake.modules.nixos.limine-boot = {
    boot.loader = {
      limine = {
        enable = true;
        enableEditor = true;
        # this is the resolution of my main monitor (ultrawide) =
        style.interface.resolution = "3440x1440";
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
