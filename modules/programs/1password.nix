{
  flake.modules.homeManager._1password =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.ssh =
        let
          onePassPath =
            if pkgs.stdenv.isLinux then
              "~/.1password/agent.sock"
            else
              "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
        in
        {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = {
            "*" = {
              identityAgent = onePassPath;
            };

            "github.com" = {
              hostname = "github.com";
              user = "git";
            };
          };
        };

      programs.git =
        let
          singingProgram =
            if pkgs.stdenv.isDarwin then
              "${pkgs._1password-gui.outPath}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
            else
              "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        in
        {
          signing = {
            format = "ssh";
            signer = singingProgram;
            key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPBRWC7uEA0ysNzYHMERozjdRuPUSD5kgwwmDH6DHmr";
            signByDefault = true;
          };
          settings.url = {
            "ssh://git@github.com/" = {
              insteadOf = "https://github.com/";
            };
          };
        };
    };

  flake.modules.darwin._1password =
    { pkgs, ... }:
    {
      programs._1password.enable = true;
      programs._1password-gui = {
        package = pkgs.unstable._1password-gui;
        enable = true;
      };
    };

  flake.modules.nixos._1password = {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "alex" ];
    };
  };
}
