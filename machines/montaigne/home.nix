{ pkgs, ... }:
let
  emacs = pkgs.emacs30-pgtk.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # Fix OS window role (needed for window managers like yabai)
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/fix-window-role.patch";
        sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
      })
      # Enable rounded window with no decoration
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
        sha256 = "uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
      })
      # Make Emacs aware of OS-level light/dark mode
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
        sha256 = "3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
      })
    ];
  });

in
{
  home = {
    homeDirectory = "/Users/pml";
    username = "pml";

    packages = with pkgs; [
      ffmpeg
      jq
      yt-dlp
    ];
  };

  programs.git = {
    enable = true;
    userEmail = "git@monologique.me";
    userName = "monologique";
  };
  
  programs.emacs = {
    enable = true;
    package = emacs;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;

    dirHashes = {
      docs = " $HOME/Documents";
      dl = "$HOME/Downloads";
      repos = "$HOME/Documents/Repositories";
    };

    dotDir = ".config/zsh";

    history = {
      expireDuplicatesFirst = true;
      # findNoDups = true; only on unstable, using initExtraFirst for now
      ignoreDups = true;
      ignoreSpace = true;
      save = 10000;
      # saveNoDups = true; only on unstable using initExtraFirst for now
      size = 10000;
    };

    initExtraFirst = ''
      export XDG_CACHE_DIR=$HOME/Library/Caches
      export XDG_CONFIG_HOME=$HOME/.config
      export GOPATH=$XDG_CACHE_DIR/go
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_FIND_NO_DUPS
    '';

    plugins = [ ];

    profileExtra = ''
      export XDG_CACHE_DIR=$HOME/Library/Caches
      export XDG_CONFIG_HOME=$HOME/.config

      export GOPATH=$XDG_CACHE_DIR/go
      export EDITOR="vim"

      # Homebrew shell activation
      if [[ -d "/opt/homebrew"  ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)";
	  fpath+=/opt/homebrew/share/zsh/site-functions
      fi
    '';

    shellAliases = {
      ls = "ls -G";
      ll = "ls -l";
      la = "ls -la";
    };
  };

  home.stateVersion = "24.11";
}
