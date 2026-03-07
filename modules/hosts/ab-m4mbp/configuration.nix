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

      programs.ssh.extraConfig = ''
      Host playtime
        HostName playtime.orca-char.ts.net
        # ssh for synology nas is on port 28
        # ssh for proxmox qdevice is on port 22
        Port 28
        User alex

      Host union
        HostName union.orca-char.ts.net
        User root

      Host santiago
        HostName 10.1.1.35
        User root

      Host docker
        HostName 10.1.15.127
        User root

      Host monitoring
        HostName 10.1.15.128
        User root

      Host caddy
        HostName 10.1.15.109
        User root

      Host whatbox
        HostName mimas.whatbox.ca
        User zucchinize

      Host nowhere
        HostName nowhere.noodle.sh
        User root

      Host heat
        HostName heat.noodle.sh

      Host *sr.ht
        IdentityFile ~/.ssh/srht.id_rsa
        PreferredAuthentications publickey
      '';
    };

    networking.hostName = "ab-m4mbp";

    system = {
      primaryUser = "alex";
      stateVersion = 6;
    };
  };
}
