{
  flake.modules.nixos.ups = {
    power.ups = {
      enable = true;
      mode = "netserver";
      openFirewall = true;
    };
  };
}
