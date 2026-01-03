# Alex's Nix Configurations

uses [dendritic nix](https://github.com/mightyiam/dendritic) setup using this
guide [on dendritic design](https://github.com/Doc-Steve/dendritic-design-with-flake-parts).

all files are imported automatically. files are broken up into features, that
then apply laterally across all configurations

## Hosts

| host     | purpose         | notes                             |
| -------- | --------------- | --------------------------------- |
| ab-m4mbp | personal laptop | m4 max macbook pro                |
| heat     |                 | oracle cloud free tier arm server |
| nowhere  |                 | racknerd yearly vps               |
| qatsi    |                 | local vm on santiago in homelab   |

## Deployment

using [deploy-rs](https://github.com/serokell/deploy-rs) just run
`nix run github:serokell/deploy-rs -- .#<host>.<profile>` `profile` defaults to
`system`

## Deployment (Old Way)

to deploy to a single host remotely on a local computer

`export SERVER=heat; nix run nixpkgs#nixos-rebuild -- --target-host $SERVER --build-host $SERVER --use-remote-sudo --flake ".#$SERVER" --fast switch`
