{ inputs, ... }:
let
  username = "alex";
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPBRWC7uEA0ysNzYHMERozjdRuPUSD5kgwwmDH6DHmr";

  flake.modules.homeManager.${username} =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        system-default
        editors
        zsh
      ];

      home.username = "${username}";
      home.packages = with pkgs; [
        mediainfo
      ];
    };

  flake.modules.darwin.${username} =
    { pkgs, ... }:
    {
      home-manager.users."${username}" = {
        imports = [ inputs.self.modules.homeManager."${username}" ];
      };

      system.primaryUser = "${username}";

      users.users."${username}" = {
        name = "${username}";
        shell = pkgs.zsh;
      };
      programs.zsh.enable = true;

      # nix darwin doesn't ovver programs.zsh.shellAliases so we need to
      # set them using this
      environment.shellAliases = {
        # mac specific aliases
        ql = "qlmanage";
        icloud = "cd ~/Library/Mobile\ Documents";
      };
    };

  flake.modules.nixos.${username} =
    { pkgs, ... }:
    {
      home-manager.users."${username}" = {
        imports = [ inputs.self.modules.homeManager."${username}" ];
      };

      users.users."${username}" = {
        isNormalUser = true;

        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [ sshKey ];
        shell = pkgs.zsh;
      };

      programs.zsh.enable = true;

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
in
{
  inherit flake;
}
