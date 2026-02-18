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

      programs.zed-editor = {
        enable = true;
        extensions = [
          "elixir"
          "nix"
        ];
        userSettings = {
          theme = {
            mode = "system";
            light = "Catppuccin Latte";
            dark = "Catppuccin Frappé";
          };
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
