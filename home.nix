{
  # config,
  pkgs,
  lib,
  ...
}:

{
  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "alex";
    homeDirectory = lib.mkDefault "/home/alex";

    packages = with pkgs; [
      bat
      eza
      nh
      just
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.git = {
  #   userName = "Alex Bierwagen";
  #   userEmail = "alex@bierwagen.dev";
  # };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    # plugins = [ pkgs.vimPlugins.nvim-tree-lua ];
  };

  programs.helix = {
    enable = true;
    extraPackages = [ pkgs.nixd ];
    languages = {
      languages = [
        {
          name = "nix";
          auto-format = true;
        }
      ];
      language-server.nixd = {
        command = "nixd";
        args = [ "--semantic-tokens=true" ];
        config.nixd =
          let
            myFlake = "(builtins.getFlake toString /Users/alex/Developer/01_nix)";
            darwinOpts = "${myFlake}.darwinConfigurations.ab-m4mbp.options";
          in
          {
            formatting.command = "nixfmt";
            nixpkgs.expr = "import ${myFlake}.inputs.nixpkgs { }";
            options = {
              darwin.expr = darwinOpts;
              home-manager.expr = "${darwinOpts}.home-manager.users.type.getSubOptions []";
            };
          };
      };
    };
    settings = {
      theme = "penumbra+";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
    };
  };

  programs.nh = {
    enable = true;
    flake = "/home/alex/nix";
    darwinFlake = "/Users/alex/Developer/01_nix";
  };
}
