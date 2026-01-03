{ inputs, ... }:
{
  flake.modules.generic.constants =
    { lib, ... }:
    {
      options.constants = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = { };
      };

      config.constants = {
        gitRevision = toString (
          inputs.self.shortRev or inputs.self.dirtyShortRev or inputs.self.lastModified or "unknown"
        );
        alex.sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPBRWC7uEA0ysNzYHMERozjdRuPUSD5kgwwmDH6DHmr";
      };
    };
}
