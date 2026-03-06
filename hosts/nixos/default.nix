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

  fileSystems."/games/steam" = {
    device = "/dev/disk/by-uuid/36c6b161-b08d-4950-ad38-aaa765c37e7d";
    fsType = "ext4";
    options = [ "noatime" "commit=60" ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}
