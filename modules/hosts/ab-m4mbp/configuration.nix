{
  inputs,
  ...
}:
{
  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "ab-m4mbp";
  flake.modules.darwin.ab-m4mbp = {
    imports = with inputs.self.modules.darwin; [
      system-default
    ];

    networking.hostName = "ab-m4mbp";

    system.primaryUser = "alex";
  };
}
