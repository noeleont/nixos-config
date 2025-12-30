{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Include the necessary packages and configuration for Apple Silicon support.
    ../../support/apple-silicon-support
    # Import shared modules
    ../../modules/system/nix-settings.nix
    ../../modules/system/users.nix
    ../../modules/system/locale.nix
  ];

  users.users.noeleon = {
    hashedPassword = "$6$RtiHJpMl8PeTWI5F$6cOShTcp//kwtQhmBVy1FynfObVJUPm/ZKEH9Q85a7Zvz8HBN6u4zUCsDtBSuMsrU7wyoc.aweF7yXP3pPiUF/";
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM+kU+UfhJ2hZkqBM+7OoiQwecbOjUTObwL3bCwsdwguG/50l9AWXRujEJ/MzupZTEAsVnODLGshACCkgS7HbyQ="
    ];
  };

  hardware.asahi.peripheralFirmwareDirectory = ../../support/firmware;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "m2x"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  networking.nameservers = [ "1.1.1.1" ];

  # SSH
  services.openssh.enable = true;

  # VPN
  services.tailscale.enable = true;

  programs.zsh.enable = true;


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.11"; # Did you read the comment?
}
