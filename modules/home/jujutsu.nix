{ config, ... }:
let
  # Reuse git user settings
  user = config.programs.git.settings.user;
in
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = user.name;
        email = user.email;
      };
      ui = {
        paginate = "never";
      };
    };
  };
  programs.delta.enableJujutsuIntegration = true;
}
