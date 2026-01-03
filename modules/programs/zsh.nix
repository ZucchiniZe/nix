{
  flake.modules.homeManager.zsh =
    { pkgs, lib, ... }:

    {
      programs.zsh = {
        enable = true;
        enableCompletion = false;
        antidote = {
          enable = true;
          plugins = [
            "zsh-users/zsh-completions"
            "zsh-users/zsh-autosuggestions"
            "zdharma-continuum/fast-syntax-highlighting"
            "zdharma-continuum/history-search-multi-word"
          ];
        };
        defaultKeymap = "emacs";
        history = {
          append = true;
          size = 500000;
          extended = true;
        };
        setOptions = [
          "GLOB_COMPLETE" # glob expansion
        ];
        # case insensitive tab completion with fuzzy matchin
        initContent = ''
          # 0 -- vanilla completion (abc => abc)
          # 1 -- smart case completion (abc => Abc)
          # 2 -- word flex completion (abc => A-big-Car)
          # 3 -- full flex completion (abc => ABraCadabra)
          zstyle ":completion:*" matcher-list "" \
            "m:{a-z\-}={A-Z\_}" \
            "r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}" \
            "r:|?=** m:{a-z\-}={A-Z\_}"g
        '';
        shellAliases = {
          gs = "git status -sb";
          gc = "git commit";
          gp = "git push";
          gd = "git diff";
          gl = "git lg";
          # eza prettier than ls
          ls = "${pkgs.eza}/bin/eza";
          ll = "${pkgs.eza}/bin/eza -lah --git";
          cl = "clear";
        };
      };

      programs.eza = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zoxide.enable = true;
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          # copying from https://starship.rs/presets/pure-preset
          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "$git_branch"
            "$git_state"
            "$git_status"
            "$cmd_duration"
            "$line_break"
            "$python"
            "$character"
          ];
          username.format = "[$user]($style)@";
          hostname.format = "[$hostname]($style): ";
          directory = {
            style = "blue";
            truncate_to_repo = false;
            fish_style_pwd_dir_length = 1;
          };
          character = {
            success_symbol = "[λ](purple)";
            error_symbol = "[λ](red)";
          };
          git_branch = {
            format = "[$branch]($style)";
            style = "bright-black";
          };
          git_status = {
            format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
            style = "cyan";
            conflicted = "";
            untracked = "";
            modified = "";
            staged = "";
            renamed = "";
            deleted = "";
            stashed = "≡";
          };
          git_state = {
            format = "\([$state( $progress_current/$progress_total)]($style)\) ";
            style = "bright-black";
          };
          cmd_duration = {
            format = "[$duration]($style)";
            style = "yellow";
          };
          python = {
            format = "[$virtualenv]($style)";
            style = "bright-black";
          };
        };
      };
    };

}
