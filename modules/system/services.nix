{ config, pkgs, lib, ... }:

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

  # Caps lock rebinding
  hardware.uinput.enable = lib.mkDefault true;
  services.kanata = {
    enable = lib.mkDefault  true;
    keyboards = { main.config = ''(defsrc caps) (deflayer base lctl)'';
    };
  };


  # Shell
  programs.zsh.enable = lib.mkDefault true;
}
