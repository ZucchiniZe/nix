{
  flake.modules.homeManager._1password =
    { pkgs, ... }:
    {
      programs.ssh =
        let
          onePassPath =
            if pkgs.stdenv.isLinux then
              "~/.1password/agent.sock"
            else
              "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
        in
        {
          enable = true;
          extraConfig = ''
            		Host *
               			IdentityAgent ${onePassPath}
          '';
        };
    };

  flake.modules.darwin._1password = {
    programs._1password.enable = true;
    programs._1password-gui.enable = true;
  };

  flake.modules.nixos._1password = {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "alex" ];
    };
  };
}
