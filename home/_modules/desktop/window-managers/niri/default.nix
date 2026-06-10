{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Configure Niri window manager";
  };

  config = mkIf moduleConfig.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri;

      settings = {
        outputs."eDP-1" = {
          mode = {
            width = 1920;
            height = 1200;
            refresh = 59.999;
          };
          focus-at-startup = true;
          scale = 1.0;
        };

        outputs."DP-2" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 319.999;
          };
          focus-at-startup = true;
        };

        input = {
          mouse = {
            accel-speed = -0.25;
            accel-profile = "flat";
          };
          touchpad = {
            natural-scroll = true;
            tap = true;
            accel-profile = "flat";
            dwt = true;
          };
        };

        prefer-no-csd = true;
        environment = {
          DISPLAY = ":0";
          GTK_USE_PORTAL = "1";
          MOZ_ENABLE_WAYLAND = "1";
          XDG_MENU_PREFIX = "plasma-";
          QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
          GTK_DECORATION_LAYOUT = "";
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";
          QT_ENABLE_HIGHDPI_SCALING = "1";
        };

        layout = {
          gaps = 17;
          default-column-width = {proportion = 0.5;};
        };

        spawn-at-startup = [
          {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
          {command = ["swayidle" "-w" "timeout" "300" "loginctl lock-session" "before-sleep" "loginctl lock-session"];}
          {command = ["dbus-update-activation-environment" "--systemd" "DISPLAY" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"];}
          # {command = ["gnome-keyring-daemon" "--start" "--components=secrets"];} система дэ всё заапустит
          {command = ["${pkgs.waybar}/bin/waybar"];}
          {command = ["${pkgs.kdePackages.kded}/bin/kded6"];}
          {command = ["${pkgs.kdePackages.kservice}/bin/kbuildsycoca6" "--noincremental"];}
        ];

        window-rules = [
          {
            geometry-corner-radius = {
              bottom-left = 9.0;
              bottom-right = 9.0;
              top-left = 9.0;
              top-right = 9.0;
            };
            focus-ring.width = 2;
            border.width = 2;
            clip-to-geometry = true;
            draw-border-with-background = false;
          }
          {
            matches = [
              {title = "^Steam$";}
              {title = "^Friends List$";}
            ];
            default-column-width = {proportion = 0.5;};
          }
          {
            matches = [
              {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              }
              {
                app-id = "firefox$";
                title = "^Картинка в картинке$";
              }
            ];
            default-floating-position = {
              x = 15;
              y = 15;
              relative-to = "bottom-right";
            };
            baba-is-float = true;
            open-floating = true;
            open-focused = false;
          }
          {
            matches = [
              {title = "^notificationtoasts";}
            ];
            open-focused = false;
            baba-is-float = true;
            default-floating-position = {
              x = 15;
              y = 15;
              relative-to = "bottom-left";
            };
            open-floating = true;
          }
          {
            matches = [
              {app-id = "steam";}
            ];
          }
        ];

        animations = {
          slowdown = 1.0;
          workspace-switch.kind.spring = {
            damping-ratio = 0.8;
            stiffness = 600;
            epsilon = 0.0001;
          };
          window-open.kind.spring = {
            damping-ratio = 0.7;
            stiffness = 800;
            epsilon = 0.0001;
          };
          horizontal-view-movement.kind.spring = {
            damping-ratio = 0.8;
            stiffness = 600;
            epsilon = 0.0001;
          };
          window-close.kind.spring = {
            damping-ratio = 0.7;
            stiffness = 800;
            epsilon = 0.0001;
          };
          window-resize.kind.spring = {
            damping-ratio = 0.7;
            stiffness = 800;
            epsilon = 0.0001;
          };
          window-movement.kind.spring = {
            damping-ratio = 0.7;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };

        binds =
          {
            "Mod+T".action.spawn = ["${pkgs.kitty}/bin/kitty"];
            "Mod+W".action.spawn = ["${pkgs.zen-browser}/bin/zen-beta"];
            "Mod+E".action.spawn = ["${pkgs.kdePackages.dolphin}/bin/dolphin"];
            "Mod+R".action.spawn = ["${pkgs.rofi}/bin/rofi" "-show" "drun"];
            "Mod+C".action.spawn = ["${pkgs.vscode}/bin/code"];

            "Mod+Q".action.close-window = {};
            "Mod+Shift+Ctrl+Q".action.quit.skip-confirmation = false;
            "Mod+L".action.spawn = ["loginctl" "lock-session"];

            "Mod+F".action.maximize-column = {};
            "Mod+Shift+F".action.toggle-window-floating = {};
            "Mod+Ctrl+F".action.fullscreen-window = {};
            "Mod+Shift+S".action.screenshot = {show-pointer = true;};
            "Mod+Left".action.focus-column-left = {};
            "Mod+Right".action.focus-column-right = {};
            "Mod+Up".action.focus-window-or-workspace-up = {};
            "Mod+Down".action.focus-window-or-workspace-down = {};
            "Mod+WheelScrollUp".action.focus-column-left = {};
            "Mod+WheelScrollDown".action.focus-column-right = {};
            "Mod+Ctrl+WheelScrollUp".action.focus-window-or-workspace-up = {};
            "Mod+Ctrl+WheelScrollDown".action.focus-window-or-workspace-down = {};
            "Mod+Shift+Left".action.move-column-left = {};
            "Mod+Shift+Right".action.move-column-right = {};
            "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = {};
            "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = {};
            "Mod+Alt+Left".action.set-column-width = "-10%";
            "Mod+Alt+Right".action.set-column-width = "+10%";
            "Mod+Alt+Up".action.set-window-height = "-10%";
            "Mod+Alt+Down".action.set-window-height = "+10%";

            "XF86AudioPlay".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
            "XF86AudioPause".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
            "XF86AudioNext".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "next"];
            "XF86AudioPrev".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "previous"];
            "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+"];
            "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%-"];
          }
          // (builtins.listToAttrs (builtins.concatLists (builtins.genList (
              i: let
                key =
                  if i == 9
                  then "0"
                  else toString (i + 1);
                ws = i + 1;
              in [
                {
                  name = "Mod+${key}";
                  value.action.focus-workspace = ws;
                }
                {
                  name = "Mod+Shift+${key}";
                  value.action.move-window-to-workspace = ws;
                }
              ]
            )
            10)));
      };
    };

    services.swaync.enable = true;
    services.status-notifier-watcher.enable = true;

    services.gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };

    xdg.portal = {
      enable = true;
      config.niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
      config.common.default = "*";
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };

    home.packages = with pkgs; [
      swaybg
      pear-desktop
      libsecret
      shared-mime-info
      kdePackages.dolphin
      kdePackages.kio-extras
      kdePackages.qtwayland
      kdePackages.kded
      kdePackages.kservice
      kdePackages.plasma-workspace
      kdePackages.frameworkintegration
      kdePackages.ark
      adwaita-qt6
      xdg-desktop-portal-gnome
      playerctl
    ];
  };
}
