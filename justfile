edit-secrets:
    EDITOR='zed -w' SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt nix run nixpkgs#sops secrets/default.yaml

deploy-darwin:
    sudo darwin-rebuild switch --flake .

deploy-anywhere host address:
    nix run github:nix-community/nixos-anywhere -- \
     --generate-hardware-config nixos-generate-config ./hosts/{{ host }}/hardware-configuration.nix \
     --flake .#{{ host }} --target-host {{ address }} --debug --show-trace
