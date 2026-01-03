let
  genericPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bat
        eza
        fd
        git
        home-manager
        jujutsu
        just
        neovim
        nh
        nil
        nixd
        nixfmt
        restic
        uv
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
          url = {
            "ssh://git@github.com/" = {
              insteadOf = "https://github.com/";
            };
          };
        };
      };

      programs.git.includes = [
        {
          contents = {
            alias = {
              lg = "!\"git lg1\"";
              lg1 = "!\"git lg1-specific --all\"";
              lg2 = "!\"git lg2-specific --all\"";
              lg3 = "!\"git lg3-specific --all\"";

              lg1-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
              lg2-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
              lg3-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'";
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
