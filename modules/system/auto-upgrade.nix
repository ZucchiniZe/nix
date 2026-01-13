{
	flake.modules.nixos.auto-upgrade = {
		system.autoUpgrade = {
			enable = true;
			flake = "github:ZucchiniZe/nix";
			dates = "2:00";
			allowReboot = true;
		};
	};
}