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
    ../../modules/system/services.nix
    ../../modules/system/users.nix
    ../../modules/system/locale.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "m2mx"; # Define your hostname.

  virtualisation.docker.enable = true;
  users.users.noeleon.users.users.noeleon = {
    hashedPassword = "$6$RtiHJpMl8PeTWI5F$6cOShTcp//kwtQhmBVy1FynfObVJUPm/ZKEH9Q85a7Zvz8HBN6u4zUCsDtBSuMsrU7wyoc.aweF7yXP3pPiUF/";
    extraGroups = [ "docker" ];
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  networking.nameservers = [ "1.1.1.1" ];

  # TODO: replace with map of headless hosts
  programs.ssh.extraConfig = ''
    Host nixos-1
      ForwardAgent yes
    Host m2x
      ForwardAgent yes
    Host m2ma
      ForwardAgent yes
  '';

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    # Flakes clones its dependencies through the git command,
    # so git must be installed first
    git
    ghostty
  ];

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = "25.11"; # Did you read the comment?
}
