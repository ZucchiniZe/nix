# Alex's Nix Configurations

## Deployment

to deploy to a single host remotely on a local computer

`export SERVER=heat; nix run nixpkgs#nixos-rebuild -- --target-host $SERVER --build-host $SERVER --use-remote-sudo --flake ".#$SERVER" --fast switch`
