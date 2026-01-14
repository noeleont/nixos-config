{ pkgs, ... }:
{
    # Enable Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Enable ports for Steam Remote Play
    };

    # Required for Steam
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Create a dedicated user for Steam
    users.users.steam = {
      isNormalUser = true;
      description = "Steam Service Account";
      extraGroups = [ "gamemode" "input" "video" ];
      packages = with pkgs; [
        steam
        steamcmd
      ];
    };

    # Required for Steam Remote Play
    networking.firewall = {
      allowedTCPPorts = [ 27036 27037 ];
      allowedUDPPorts = [ 27031 27036 ];
    };

    # Enable sound (optional, but needed for some games)
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
}
