{
  plugins = {
    zen-mode = {
      enable = true;
      settings = {
        window = {
          backdrop = 1;
          options = {
            number = false;
            cursorline = false;
            list = false;
          };
          width = 60;
          height = 0.75;
        };
      };
    };
    twilight.enable = true;
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";
          icons_enabled = true;
          component_separators = {
            left = "|";
            right = "|";
          };
          section_separators = {
            left = "";
            right = "";
          };
        };
      };
    };

    web-devicons = {
      enable = true;
    };
  };
}
