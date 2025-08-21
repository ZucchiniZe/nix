# Alex's Nix Configurations

## Deployment

using [deploy-rs](https://github.com/serokell/deploy-rs) just run
`nix run github:serokell/deploy-rs -- .#<host>.<profile>` `profile` defaults to `system`

## Deployment (Old Way)

to deploy to a single host remotely on a local computer

`export SERVER=heat; nix run nixpkgs#nixos-rebuild -- --target-host $SERVER --build-host $SERVER --use-remote-sudo --flake ".#$SERVER" --fast switch`
