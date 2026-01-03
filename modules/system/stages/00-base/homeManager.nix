{
  inputs,
  ...
}:
{

  flake.modules.homeManager.system-base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home.homeDirectory =
        if pkgs.stdenv.isDarwin then
          (lib.mkForce "/Users/${config.home.username}")
        else
          "/home/${config.home.username}";
      home.stateVersion = "25.05";
    };
}
