{
  flake.modules.homeManager.signed-git =
    { config, ... }:
    {
      # only enable when using 1password on mac
      programs.git = {
        signing = {
          format = "ssh";
          signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          key = config.constants.alex.sshKey;
          signByDefault = true;
        };
        settings.url = {
          "ssh://git@github.com/" = {
            insteadOf = "https://github.com/";
          };
        };
      };
    };
}
