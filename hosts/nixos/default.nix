{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/steam.nix
    ../../modules/system/nix-settings.nix
    ../../modules/system/services.nix
    ../../modules/system/users.nix
    ../../modules/system/locale.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable NetworkManager for network management
  networking.networkmanager.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  environment.systemPackages = with pkgs; [
    git
    home-manager
    gnumake
    docker-machine-kvm2
  ];

  boot.kernelModules = [ "kvm" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };
  virtualisation.docker.enable = true;

  # System-specific user groups for nixos
  common.user.additionalGroups = [
    "libvirtd"
    "docker"
    "kvm"
    "networkmanager"
  ];

  # System-specific user configuration
  users.users.noeleon = {
    group = "users";
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNcR+zomXsTtXI67NFPw6OAVyXBKNEWCg6r09mnWF0MVBnDO4Off6aAiNlbO2cnZsZzwerxmLZLO9JBQXLUbeq4="
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKRXK2tzPbJyZZceneFihtO6GsO41f4CxZ15vnKv9nfAmklRpt9crNVl7H2MmsA5rZWRaNgrkbvFZGdpcP5mups="
    ];
  };

  services.dnsmasq.enable = false;

  programs = {
    virt-manager.enable = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
