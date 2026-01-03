{ inputs, ... }:
let
  username = "alex";
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPBRWC7uEA0ysNzYHMERozjdRuPUSD5kgwwmDH6DHmr";

  flake.modules.homeManager.${username} = { };
  flake.modules.nixos.${username} = {
    users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ sshKey ];
    };

    # enable passwordless sudo
    security.sudo.extraRules = [
      {
        users = [ username ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
  flake.modules.darwin.${username} = { };
in
{
  inherit flake;
}
