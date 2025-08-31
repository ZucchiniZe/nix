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
    shellAliases = {
      gs = "git status -sb";
      gc = "git commit";
      gp = "git push";
      gd = "git diff";
      gl = "git log";
      # eza prettier than ls
      ls = "eza";
      ll = "eza -lah --git";
      icloud = "cd ~/Library/Mobile\ Documents";
      cl = "clear";
      # quicklook
      ql = "qlmanage";
      testing = "echo nixed";
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

  programs.nh = {
    enable = true;
    darwinFlake = "/Users/alex/Development/01_nix/flake.nix";
  };
}
