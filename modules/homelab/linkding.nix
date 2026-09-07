{
	flake.modules.nixos.linkding =
		{ config, lib, ... }:
		let
			service = "linkding";
			cfg = config.homelab.services.${service};
			fullUrl = "${service}.${config.homelab.baseDomain}";
		in
		{
			options.homelab.services.${service} = {
				enable = lib.mkEnableOption "enable linkding";
				port = lib.mkOption {
          type = lib.types.int;
          default = 9090;
        };
        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/linkding";
        };
			};
			config = lib.mkIf cfg.enable {
				services.${service} = {
					enable = true;
					dataDir = cfg.dataDir;
					database.type = "sqlite";
				};

				services.caddy.virtualHosts.${fullUrl}.extraConfig = ''
					reverse_proxy http://localhost:${cfg.port}
				'';
			};
		};
}
