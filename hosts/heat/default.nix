{
  # config,
  # lib,
  inputs,
  pkgs,
  gitRevision,
  ...
}:

let
  vars = {
    hostname = "heat";
    username = "alex";
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPBRWC7uEA0ysNzYHMERozjdRuPUSD5kgwwmDH6DHmr";
    locale = "en_US.UTF-8";
    timezone = "America/Los_Angeles";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.alex = ../../home.nix;
    }
    inputs.disko.nixosModules.disko
    ./disk-config.nix
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

  systemd.targets.multi-user.enable = true;

  networking = {
    hostName = vars.hostname;
    defaultGateway = "10.0.0.1";
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          # Use IP address configured in the Oracle Cloud web interface
          address = "10.0.0.3";
          prefixLength = 24;
        }
      ];
      # Only "required" for IPv6, can be false if only IPv4 is needed
      useDHCP = true;
    };
    # Note: you also need to configure open ports in the Oracle Cloud web interface
    # (Virtual Cloud Network -> Security Lists -> Ingress Rules)
    firewall = {
      # (both optional)
      logRefusedConnections = false;
      rejectPackets = true;
    };
    networkmanager.enable = true;
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

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Disable documentation for minimal install.
  documentation.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
