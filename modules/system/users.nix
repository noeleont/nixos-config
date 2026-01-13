{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.common.user = {
    additionalGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional groups for the noeleon user";
    };
  };

  config = {
    users.users.noeleon = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
        "uinput"
      ]
      ++ config.common.user.additionalGroups;
    };

    users.defaultUserShell = pkgs.zsh;
  };
}
