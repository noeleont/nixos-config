{ pkgs, inputs, ... }:
{

  imports = [
    ../../modules/system/nix-settings.nix
  ];

  environment = {
    pathsToLink = [ "/share/zsh" ];
  };

  # Required for homebrew
  system.primaryUser = "noeleon";
  homebrew = {
    enable = true;
    # TODO: update with folder
    masApps = {
      "Tailscale" = 1475387142;
      "iA Writer" = 775737590;
      "Things 3" = 904280696;
    };

    casks = [
      "secretive"
      "orbstack"
      "ghostty"
    ];
  };

  # Necessary for using flakes on this system.
  nix.package = pkgs.lix;

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  system = {

    defaults = {
      dock = {
        autohide = true;
        orientation = "left";
        show-recents = false;
      };
      NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.noeleon = {
    name = "noeleon";
    home = "/Users/noeleon";
  };
}
