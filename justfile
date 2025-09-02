deploy-darwin:
  sudo darwin-rebuild switch --flake .

deploy-anywhere host address:
  nix run github:nix-community/nixos-anywhere -- \
   --generate-hardware-config nixos-generate-config ./hosts/{{host}}/hardware-configuration.nix \
   --flake .#{{host}} --target-host {{address}} --build-on-remote
