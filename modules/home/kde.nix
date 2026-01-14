{
  config,
  lib,
  pkgs,
  ...
}:
{

  options.kde.krohnkite.screenGap = lib.mkOption {
    type = lib.types.ints.positive;
    default = 100;
    description = "Screen Gap Krohnkite should use";
  };

  config = {
    home.packages = with pkgs; [
      kde-rounded-corners
      kdePackages.krohnkite
    ];

    # Set gpg agent specific to KDE/Kwallet
    services.gpg-agent = {
      pinentry.package = lib.mkForce pkgs.kwalletcli;
      extraConfig = "pinentry-program ${pkgs.kwalletcli}/bin/pinentry-kwallet";
    };

    programs.plasma = {
      enable = true;

      fonts = {
        fixedWidth = {
          family = "JetBrainsMono Nerd Font Mono";
          pointSize = 11;
        };
        general = {
          family = "Roboto";
          pointSize = 11;
        };
        menu = {
          family = "Roboto";
          pointSize = 11;
        };
        small = {
          family = "Roboto";
          pointSize = 8;
        };
        toolbar = {
          family = "Roboto";
          pointSize = 11;
        };
        windowTitle = {
          family = "Roboto";
          pointSize = 11;
        };
      };

      hotkeys.commands = {
        launch-ghostty = {
          name = "Launch Ghostty";
          key = "Meta+Shift+Return";
          command = "ghostty";
        };
      };

      krunner.activateWhenTypingOnDesktop = false;

      kwin = {
        nightLight = {
          enable = true;
          location.latitude = "46.95";
          location.longitude = "7.45";
          mode = "location";
          temperature.night = 4000;
        };

        virtualDesktops = {
          number = 5;
          rows = 1;
        };
      };

      overrideConfig = true;

      panels = [
        {
          floating = false;
          height = 34;
          lengthMode = "fill";
          location = "top";
          widgets = [
            {
              name = "org.dhruv8sh.kara";
              config = {
                general = {
                  animationDuration = 0;
                  highlightType = 1;
                  spacing = 3;
                  type = 1;
                };
                type1 = {
                  fixedLen = 3;
                  labelSource = 0;
                };
              };
            }
            "org.kde.plasma.panelspacer"
            {
              name = "org.kde.plasma.digitalclock";
              config = {
                Appearance = {
                  autoFontAndSize = false;
                  customDateFormat = "ddd d";
                  dateDisplayFormat = "BesideTime";
                  dateFormat = "custom";
                  fontSize = 11;
                  fontStyleName = "Regular";
                  fontWeight = 400;
                  use24hFormat = 2;
                };
              };
            }
            "org.kde.plasma.panelspacer"
            {
              systemTray = {
                icons.scaleToFit = true;
                items = {
                  showAll = false;
                  shown = [
                    "org.kde.plasma.networkmanagement"
                    "org.kde.plasma.volume"
                  ];
                  hidden = [
                    "org.kde.plasma.battery"
                    "org.kde.plasma.brightness"
                    "org.kde.plasma.clipboard"
                    "org.kde.plasma.devicenotifier"
                    "org.kde.plasma.keyboardlayout"
                    "org.kde.plasma.mediacontroller"
                    "plasmashell_microphone"
                    "xdg-desktop-portal-kde"
                  ];
                  configs = {
                    "org.kde.plasma.notifications".config = {
                      Shortcuts = {
                        global = "Meta+N";
                      };
                    };
                  };
                };
              };
            }
          ];
        }
      ];

      powerdevil = {
        AC = {
          autoSuspend.action = "nothing";
          dimDisplay.enable = false;
          powerButtonAction = "shutDown";
          turnOffDisplay.idleTimeout = "never";
        };
        battery = {
          autoSuspend.action = "nothing";
          dimDisplay.enable = false;
          powerButtonAction = "shutDown";
          turnOffDisplay.idleTimeout = "never";
        };
      };

      session = {
        general.askForConfirmationOnLogout = false;
        sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };

      shortcuts = {
        ksmserver = {
          "Lock Session" = [
            "Screensaver"
            "Ctrl+Alt+L"
          ];
          "LogOut" = [
            "Ctrl+Alt+Q"
          ];
        };

        kwin = {
          "KrohnkiteMonocleLayout" = [ ];
          "Switch to Desktop 1" = "Meta+1";
          "Switch to Desktop 2" = "Meta+2";
          "Switch to Desktop 3" = "Meta+3";
          "Switch to Desktop 4" = "Meta+4";
          "Switch to Desktop 5" = "Meta+5";
          "Switch to Desktop 6" = "Meta+6";
          "Switch to Desktop 7" = "Meta+7";
          "Window Close" = "Meta+Q";
          "Window Fullscreen" = "Meta+M";
          "Window Move Center" = "Ctrl+Alt+C";
        };

        plasmashell = {
          "show-on-mouse-pos" = "";
        };

        "services/org.kde.dolphin.desktop"."_launch" = "Meta+Shift+F";
      };

      window-rules = [
        {
          apply = {
            noborder = {
              value = true;
              apply = "initially";
            };
          };
          description = "Hide titlebar by default";
          match = {
            window-class = {
              value = ".*";
              type = "regex";
            };
          };
        }
        {
          apply = {
            desktops = "Desktop_4";
            desktopsrule = "3";
            fsplevel = "4";
            fsplevelrule = "2";
            minimizerule = "2";
          };
          description = "Assign Steam to Desktop 4";
          match = {
            window-class = {
              value = "steam";
              type = "exact";
              match-whole = false;
            };
            window-types = [ "normal" ];
          };
        }
        {
          apply = {
            desktops = "Desktop_5";
            desktopsrule = "3";
            fsplevel = "4";
            fsplevelrule = "2";
          };
          description = "Assign Steam Games to Desktop 5";
          match = {
            window-class = {
              value = "steam_app_";
              type = "substring";
              match-whole = false;
            };
          };
        }
      ];

      workspace = {
        colorScheme = "BreezeDark";
      };

      configFile = {
        baloofilerc."Basic Settings"."Indexing-Enabled" = false;
        gwenviewrc.ThumbnailView.AutoplayVideos = true;
        kdeglobals = {
          General = {
            BrowserApplication = "firefox-browser.desktop";
          };
          KDE = {
            AnimationDurationFactor = 0;
          };
        };
        klaunchrc.FeedbackStyle.BusyCursor = false;
        klipperrc.General.MaxClipItems = 1000;
        kwinrc = {
          Effect-overview.BorderActivate = 9;
          Plugins = {
            blurEnabled = false;
            dimscreenEnabled = false;
            krohnkiteEnabled = true;
            screenedgeEnabled = false;
          };
          "Round-Corners" = {
            ActiveOutlineAlpha = 255;
            ActiveOutlineUseCustom = false;
            ActiveOutlineUsePalette = true;
            AnimationDuration = 0;
            DisableOutlineTile = false;
            DisableRoundTile = false;
            InactiveCornerRadius = 8;
            InactiveOutlineAlpha = 0;
            InactiveSecondOutlineThickness = 0;
            OutlineThickness = 1;
            SecondOutlineThickness = 0;
            Size = 8;
            UseNativeDecorationShadows = false;
          };
          "Script-krohnkite" = {
            floatingClass = "org.freedesktop.impl.portal.desktop.kde";
            newWindowPosition = 1;
            screenGapBetween = config.kde.krohnkite.screenGap;
            screenGapBottom = config.kde.krohnkite.screenGap;
            screenGapLeft = config.kde.krohnkite.screenGap;
            screenGapRight = config.kde.krohnkite.screenGap;
            screenGapTop = config.kde.krohnkite.screenGap;
          };
          Windows = {
            DelayFocusInterval = 0;
            FocusPolicy = "FocusFollowsMouse";
          };
        };
        plasmanotifyrc = {
          DoNotDisturb = {
            WhenFullscreen = false;
            WhenScreenSharing = false;
            WhenScreensMirrored = false;
          };
          Notifications = {
            PopupPosition = "TopRight";
            PopupTimeout = 7000;
          };
        };
        plasmarc.OSD.Enabled = false;
      };
      dataFile = {
        "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
        "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
      };
    };
  };
}
