{ inputs, ... }:
let
  username = "alex";
  secure-git =
    { config, ... }:
    {
      # only enable on macos with 1pass
      programs.git = {
        signing = {
          format = "ssh";
          signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          key = config.constants.alex.sshKey;
        };
        settings.url = {
          "ssh://git@github.com/" = {
            insteadOf = "https://github.com/";
          };
        };

      };
    };
in
{
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
    { pkgs, config, ... }:
    {
      home-manager.users."${username}" = {
        imports = [
          inputs.self.modules.homeManager."${username}"
          secure-git
        ];
      };

      system.primaryUser = "${username}";

      users.users."${username}" = {
        name = "${username}";
        openssh.authorizedKeys.keys = [ config.constants.alex.sshKey ];
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
    { pkgs, config, ... }:
    {
      home-manager.users."${username}" = {
        imports = [ inputs.self.modules.homeManager."${username}" ];
      };

      users.users."${username}" = {
        isNormalUser = true;

        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [ config.constants.alex.sshKey ];
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
}
