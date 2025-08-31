{
  # config,
  pkgs,
  lib,
  ...
}:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "alex";
  home.homeDirectory = lib.mkDefault "/home/alex";

  home.packages = with pkgs; [
    bat
    eza
    nh
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
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
      gl = "git log";
      # eza prettier than ls
      ls = "${pkgs.eza}/bin/eza";
      ll = "${pkgs.eza}/bin/eza -lah --git";
      icloud = "cd ~/Library/Mobile\ Documents";
      cl = "clear";
      # quicklook
      ql = "qlmanage";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    # plugins = [ pkgs.vimPlugins.nvim-tree-lua ];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
      directory.style = "blue";
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
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
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

  programs.nh = {
    enable = true;
    darwinFlake = "/Users/alex/Development/01_nix/flake.nix";
  };
}
