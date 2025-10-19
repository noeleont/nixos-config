{ pkgs-unstable, ... }:
{
  xdg.configFile."zed/themes/1984.json" = {
    source = ./theme.json;
  };

  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;

    extensions = [
      "nix"
      "toml"
      "elixir"
      "make"
    ];

    userSettings = {
      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      vim_mode = true;

      theme = {
        mode = "dark";
        light = "One Light";
        dark = "1984 Cyberpunk";
      };

      ui_font_size = 16;
      buffer_font_size = 12;
      autosave = "on_focus_change";
    };
  };
}
