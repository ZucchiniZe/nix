{
  lib,
  pkgs,
  inputs,
  gitRevision,
  ...
}:
let
  vars = {
    hostname = "nowhere";
    username = "alex";
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPBRWC7uEA0ysNzYHMERozjdRuPUSD5kgwwmDH6DHmr";
    locale = "en_US.UTF-8";
    timezone = "America/Los_Angeles";
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${vars.username} = ../../home.nix;
    }
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-configuration.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = vars.hostname;
    firewall = {
      # (both optional)
      logRefusedConnections = true;
      rejectPackets = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  system.configurationRevision = gitRevision;
  time.timeZone = vars.timezone;
  i18n.defaultLocale = vars.locale;

  nix.settings.experimental-features = "nix-command flakes";

  users = {
    mutableUsers = false;
    users.${vars.username} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [ vars.sshKey ];
    };
  };

  documentation.enable = true;

  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = [ vars.username ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  programs.zsh = {
    enable = true;
    # fix zsh "no match" error by disabling globbing with the nix command
    shellAliases = {
      nix = "noglob nix";
    };
  };

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
