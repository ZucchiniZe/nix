{
  # lib,
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
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    kernelParams = [ "net.ifnames=0" ];
    initrd.systemd.enable = true;
  };
  # boot.loader.grub = {
  #   # no need to set devices, disko will add all devices that have a EF02 partition to the list already
  #   # devices = [ ];
  #   efiSupport = true;
  #   efiInstallAsRemovable = true;
  # };

  networking = {
    hostName = vars.hostname;
    firewall = {
      # (both optional)
      logRefusedConnections = true;
      rejectPackets = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };
  };

  system.configurationRevision = gitRevision;

  time.timeZone = vars.timezone;
  i18n.defaultLocale = vars.locale;

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = "nix-command flakes";
  };

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

  programs.zsh = {
    enable = true;
    # fix zsh "no match" error by disabling globbing with the nix command
    shellAliases = {
      nix = "noglob nix";
    };
  };

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

  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
    wget
    dig
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Disable autologin.
  services.getty.autologinUser = null;

  # Disable documentation for minimal install.
  documentation.enable = true;

  system.stateVersion = "24.05";
}
