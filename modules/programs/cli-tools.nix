let
  genericPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bat
        eza
        fastfetch
        fd
        git
        home-manager
        iperf3
        jujutsu
        just
        manix
        neovim
        nh
        nil
        nixd
        nixfmt
        pciutils
        restic
        ripgrep
        usbutils
        uv
        yazi
      ];
    };
in
{
  flake.modules.homeManager.cli-tools =
    # { pkgs, ... }:
    # {
    #   home.packages = with pkgs; [
    #   ];
    {
      programs.nh = {
        enable = true;
        flake = "/home/alex/nix";
        darwinFlake = "/Users/alex/Developer/01_nix";
      };

      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "Alex Bierwagen";
            email = "me@alexb.io";
          };
          init.defaultBranch = "main";
        };
      };

      programs.git.includes = [
        {
          contents = {
            alias = {
              lg = "lg1";

              lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
              lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
              lg3 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)' --all";
            };
          };
        }
      ];

      programs.delta.enable = true;
      programs.delta.enableGitIntegration = true;
    };

  flake.modules.darwin.cli-tools = {
    imports = [ genericPackages ];
  };

  flake.modules.nixos.cli-tools = {
    imports = [ genericPackages ];
  };
}
