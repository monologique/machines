{ self, config, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Managed by Home-Manager
  programs.zsh = {
    enableGlobalCompInit = false;
    promptInit = "";
  };

  homebrew = {
    enable = true;

    casks = [
      "alfred"
      "altserver"
      "bitwig-studio"
      "discord"
      "figma"
      "firefox"
      "font-aporetic"
      "hammerspoon"
      "iterm2"
      "mos"
      "sketch"
      "zotero"
    ];

    masApps = {
      Keynote = 409183694;
      Numbers = 409203825;
      "AdGuard for Safari" = 1440147259;
      "System Color Picker" = 1545870783;
      Pages = 409201541;
    };

    onActivation = {
      cleanup = "zap";
    };

    taps = [
      "d12frosted/emacs-plus"
    ];
  };

  # networking.wg-quick.interfaces.enclosure = {
  #   address = [ "10.20.1.1/24" ];
  #   #dns = [ "10.10.1.1" ];
  #   privateKeyFile = config.age.secrets.wireguard-private-key.path;

  #   peers = [
  #     {
  #       publicKey = "6cgstwCsLAJkIH/a0vmhqvCYHT/Y7Qrpfn+tGG+Bp1M=";
  #       endpoint = "wg.enclosure.me";
  #       allowedIPs = [
  #         "10.10.1.0/24"
  #         "10.20.1.0/24"
  #       ];
  #       persistentKeepalive = 25;
  #     }
  #   ];
  # };

  # networking.search = [ "enclosure.internal" ];
  # networking.knownNetworkServices = [
  #   "Wi-Fi"
  #   "Ethernet Adaptor"
  #   "Thunderbolt Ethernet"
  # ];

  # macOS resets this file when doing a system update. As such, sudo authentication with Touch ID won’t work after a system update until the nix-darwin configuration is reapplied.
  security.pam.enableSudoTouchIdAuth = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.defaults.finder = {
    FXDefaultSearchScope = "SCcf";
    #ShowPathBar = true;
  };

  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15; # Fatest
    KeyRepeat = 2; # Fatest
    NSDocumentSaveNewDocumentsToCloud = false;
    NSWindowShouldDragOnGesture = true;
  };

  system.stateVersion = 5;
}
