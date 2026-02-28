{
  flake.modules.homeManager.editors =
    { pkgs, ... }:
    {
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
                flakePath = if pkgs.stdenv.isDarwin then "/Users/alex/Developer/01_nix" else "/home/alex/nix";
                myFlake = "(builtins.getFlake toString ${flakePath})";
              in
              {
                formatting.command = "nixfmt";
                nixpkgs.expr = "import ${myFlake}.inputs.nixpkgs { }";
                options = {
                  nixos.expr = "${myFlake}.nixosConfigurations.matcha.options";
                  darwin.expr = "${myFlake}.darwinConfigurations.ab-m4mbp.options";
                  home-manager.expr = "${myFlake}.homeConfigurations.alex.options";
                };
              };
          };
        };
        settings = {
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

      programs.zed-editor = {
        enable = true;
        package = pkgs.unstable.zed-editor;
        extensions = [
          "elixir"
          "nix"
        ];
        userSettings = {
          vim_mode = true;
          base_keymap = "Emacs";
          ui_font_size = 16;
          buffer_font_size = 14;
          autosave = "on_focus_change";
          indent_guides = {
            active_line_width = 2;
            coloring = "indent_aware";
          };
          languages = {
            "Nix" = {
              indent_guides = {
                active_line_width = 2;
                background_coloring = "disabled";
                coloring = "indent_aware";
              };
              hard_tabs = true;
              tab_size = 2;
            };
          };
        };
      };
    };
}
