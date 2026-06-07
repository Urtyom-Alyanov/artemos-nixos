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
with lib; let
  colors = config.lib.stylix.colors or {};
  fonts = config.stylix.fonts or {};
in {
  options = mkOptions {
    enable = mkEnableOption "Enable waybar configuration";
  };

  config = mkIf moduleConfig.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;

      settings = [
        {
          layer = "top";
          position = "top";
          height = 30;
          spacing = 4;

          modules-left = ["custom/nix-menu" "hyprland/workspaces" "mpris"];
          modules-center = ["hyprland/window"];
          modules-right = ["cpu" "memory" "clock#uptime" "battery" "pulseaudio" "hyprland/language" "backlight" "tray" "clock"];

          "custom/nix-menu" = {
            format = "";
            on-click = "${pkgs.rofi}/bin/rofi -show drun";
            tooltip = false;
          };

          "hyprland/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = true;
            format = "{name}";
          };

          mpris = {
            format = "{title} - {artist}";
            "format-paused" = "{status_icon} {title} - {artist}";
            "player-icons" = {
              default = " ";
              paused = " ";
            };
            "status-icons" = {paused = " ";};
            "max-length" = 40;
          };

          "hyprland/window" = {
            format = "{}";
            "separate-outputs" = true;
            icon = true;
            "icon-size" = 24;
          };

          cpu = {
            format = " {usage}%";
            interval = 1;
          };

          memory = {
            format = " {used:0.1f} / {total:0.1f} GB";
            interval = 30;
          };

          "clock#uptime" = {
            format = "󰥔 {uptime}";
            interval = 60;
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            "format-charging" = " {capacity}%";
            "format-plugged" = " {capacity}%";
            "format-alt" = "{icon} {time}";
            "format-icons" = ["" "" "" "" ""];
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            "format-bluetooth" = "{icon} {volume}%";
            "format-bluetooth-muted" = " {icon}";
            "format-muted" = " {format_source}";
            "format-icons" = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };

          "hyprland/language" = {
            format = "{}";
            "format-en" = "US";
            "format-ru" = "RU";
          };

          backlight = {
            format = "{icon} {percent}%";
            "format-icons" = ["" "" "" "" "" "" "" "" ""];
          };

          tray = {
            "icon-size" = 21;
            spacing = 10;
          };

          clock = {
            format = "%H:%M";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
        }
      ];

      style = ''
        * {
          font-family: "${fonts.monospace.name}";
          font-size: ${toString fonts.sizes.desktop}pt;
          border: none;
          border-radius: 0;
        }

        window#waybar {
          background-color: rgba(${builtins.substring 0 2 colors.base00}, ${builtins.substring 2 2 colors.base00}, ${builtins.substring 4 2 colors.base00}, 0.8);
          color: #${colors.base05};
          border-bottom: 2px solid #${colors.base01};
          transition-property: background-color;
          transition-duration: .5s;
        }

        .modules-left > widget,
        .modules-right > widget,
        #window {
          background-color: rgba(${builtins.substring 0 2 colors.base01}, ${builtins.substring 2 2 colors.base01}, ${builtins.substring 4 2 colors.base01}, 0.4);
          border: 1px solid #${colors.base02};
          color: #${colors.base05};
          border-radius: 10px;
          padding: 0 10px;
          margin: 0 5px;
        }

        #workspaces, #tray, #custom-nix-menu {
          padding: 0;
          background: none;
          border: none;
        }

        #custom-nix-menu {
          color: #${colors.base0D};
          font-size: ${toString (fonts.sizes.desktop + 4)}pt;
          padding: 0 15px 0 10px;
        }

        #workspaces button {
          padding: 0 5px;
          color: #${colors.base05};
          background: transparent;
        }

        #workspaces button:hover {
          background-color: #${colors.base02}44;
        }

        #workspaces button.active,
        #workspaces button.focused {
          background-color: #${colors.base05};
          color: #${colors.base01};
          border-radius: 8px;
        }

        #window { padding: 0 15px; }

        #cpu, 'memory', #clock.uptime, #battery, #pulseaudio, #language, #backlight {
          border: none;
          background: none;
          padding: 0 5px;
          margin: 0;
        }
      '';
    };
  };
}
