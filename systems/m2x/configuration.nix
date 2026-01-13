{
  lib,
  config,
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
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNcR+zomXsTtXI67NFPw6OAVyXBKNEWCg6r09mnWF0MVBnDO4Off6aAiNlbO2cnZsZzwerxmLZLO9JBQXLUbeq4="
    ];
  };

  hardware.asahi.peripheralFirmwareDirectory = ../../support/firmware;

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    kernelModules = [ "tg3" ];
    initrd = {
      kernelModules = [ "tg3" ];
      systemd = {
        enable = true;
        users.root.shell = "/bin/systemd-tty-ask-password-agent";
      };

      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          # this includes the ssh keys of all users in the wheel group
          authorizedKeys =
            with lib;
            concatLists (
              mapAttrsToList (
                name: user: if elem "wheel" user.extraGroups then user.openssh.authorizedKeys.keys else [ ]
              ) config.users.users
            );
          hostKeys = [ /boot/host_ecdsa_key ];
        };
      };
    };
  };

  networking = {
    interfaces.end0 = {
      name = "end0";
      ipv4.addresses = [
        {
          address = "192.168.1.10";
          prefixLength = 24;
        }
      ];

    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "end0";
    };
    hostName = "m2x";
    nameservers = [ "1.1.1.1" ];
  };

  # SSH
  services.openssh.enable = true;

  # VPN
  services.tailscale.enable = true;

  programs.zsh.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.11";
}
