{
  config,
  pkgs,
  lib,
  ...
}:

{
  # SSH
  services.openssh.enable = lib.mkDefault true;

  # VPN
  services.tailscale.enable = lib.mkDefault true;

  # Bluetooth
  hardware.bluetooth = {
    enable = lib.mkDefault true;
    powerOnBoot = lib.mkDefault true;
  };
  services.blueman.enable = lib.mkDefault true;

  # Desktop Environment
  services.xserver = {
    enable = lib.mkDefault true;
  };
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;

  # Flatpak
  services.flatpak.enable = lib.mkDefault true;

  # Caps lock rebinding
  hardware.uinput.enable = lib.mkDefault true;
  services.kanata = {
    enable = lib.mkDefault true;
    keyboards = {
      main.config = ''(defsrc caps) (deflayer base lctl)'';
    };
  };

  services.yubikey-agent = {
    enable = true;
    package = pkgs.yubikey-agent.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        (pkgs.fetchpatch {
          name = "pr-155.patch";
          url = "https://github.com/FiloSottile/yubikey-agent/pull/155.patch";
          hash = "sha256-tqPydG0NOP/q2VKqv3J6FLHknTYKaJzu6smHeqmdxJA=";
        })
      ];
      vendorHash = "sha256-7yzfLrxt/gttKmt46jeR+5M5E5expt1a7owu86kIRUs=";
    });
  };

  systemd.user.services.yubikey-agent = {
    unitConfig = {
      After = [
        "graphical-session.target"
        "gpg-agent.socket"
      ];
    };
    wantedBy = lib.mkForce [ "graphical-session.target" ];
  };

  programs.gnupg.agent = {
    enable = true;
  };

  # Shell
  programs.zsh.enable = lib.mkDefault true;

  # YubiKey PAM configuration for sudo
  security.pam.services.sudo = {
    u2fAuth = true;
  };
}
