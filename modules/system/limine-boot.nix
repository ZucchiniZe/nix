{
  flake.modules.nixos.limine-boot = { pkgs, ... }: {
    boot.loader = {
      limine = {
        enable = true;
        secureBoot.enable = true;
        # this is the resolution of my main monitor (ultrawide) =
        style.interface.resolution = "3440x1440";
      };
      efi.canTouchEfiVariables = true;
    };

    environment.systemPackages = [ pkgs.sbctl ];
  };
}
