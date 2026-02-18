{ pkgs, ... }:
{
  flake.modules.homeManager._1password =
    let
      onePassPath =
        if pkgs.stdenv.isLinux then
          "~/.1password/agent.sock"
        else
          "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    in
    {
      programs.ssh = {
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
