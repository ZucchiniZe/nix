{ inputs, ... }:
{
  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "ab-m4mbp";

  flake.modules.darwin.ab-m4mbp = {
    imports = with inputs.self.modules.darwin; [
      system-desktop
      alex
    ];

    home-manager.users."alex" = {
      imports = with inputs.self.modules.homeManager; [
        system-desktop
      ];

      programs.ssh.matchBlocks =
        let
          rootUser = host: {
            user = "root";
            hostname = host;
          };
        in
        {
          playtime = {
            hostname = "playtime.orca-char.ts.net";
            # ssh for synology nas is on port 28
            # ssh for proxmox qdevice is on port 22
            port = 28;
            user = "alex";
          };
          union = rootUser "union.orca-char.ts.net";
          santiago = rootUser "10.1.1.35";
          docker = rootUser "10.1.15.127";
          monitoring = rootUser "10.1.15.128";
          caddy = rootUser "10.1.15.109";
          whatbox = {
            hostname = "mimas.whatbox.ca";
            user = "zucchinize";
          };
          nowhere = rootUser "nowhere.noodle.sh";
          heat = {
            hostname = "heat.noodle.sh";
          };
        };
    };

    networking.hostName = "ab-m4mbp";

    system = {
      primaryUser = "alex";
      stateVersion = 6;
    };
  };
}
