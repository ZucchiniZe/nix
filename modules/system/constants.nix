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
      };
    };
}
