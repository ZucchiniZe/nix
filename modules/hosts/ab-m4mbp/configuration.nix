{ inputs, ... }:
{
  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "ab-m4mbp";

  flake.modules.darwin.ab-m4mbp = {
    imports = with inputs.self.modules.darwin; [
      system-desktop
      alex

      # 2.7 is crashing a build because of an upstream problem
      # rollback to what the _unstable_ branch is using
      inetutils-bugfix
    ];

    networking.hostName = "ab-m4mbp";

    system = {
      primaryUser = "alex";
      stateVersion = 6;
    };
  };
}
