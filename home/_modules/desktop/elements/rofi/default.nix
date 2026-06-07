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
    enable = mkEnableOption "Enable rofi launcher and theme";
  };

  config = mkIf moduleConfig.enable {
    home.packages = with pkgs; [rofi rofi-rbw];

    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      extraConfig = {
        show-icons = true;
        drun-display-format = "{icon} {name}";
      };

      plugins = with pkgs; [rofi-rbw];

      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          lightbg = lib.mkForce (mkLiteral "@active-background");
          lightfg = lib.mkForce (mkLiteral "@active-foreground");
        };

        inputbar = {
          padding = mkLiteral "4px";
          children = map mkLiteral ["prompt" "entry"];
        };

        prompt = {
          padding = mkLiteral "2px 8px";
          border-radius = mkLiteral "6px";
          background-color = mkLiteral "@active-foreground";
          text-color = lib.mkForce (mkLiteral "@background");
        };

        window = {
          width = mkLiteral "750px";
          border = mkLiteral "2px";
          border-color = mkLiteral "@active-foreground";
          border-radius = mkLiteral "10px";
        };

        entry = {
          placeholder = "Прошу Вас, artemos";
          padding = mkLiteral "2px 6px";
        };

        listview = {
          padding = mkLiteral "4px";
          enabled = true;
          columns = 3;
          lines = 4;
          dynamic = true;
          layout = mkLiteral "vertical";
          spacing = mkLiteral "4px";
          fixed-height = true;
          fixed-columns = true;
          background-color = mkLiteral "transparent";
        };

        element = {
          enabled = true;
          orientation = mkLiteral "vertical";
          cursor = mkLiteral "pointer";
          padding = mkLiteral "20px 10px";
          spacing = mkLiteral "15px";
          border-radius = mkLiteral "6px";
          background-color = mkLiteral "transparent";
        };

        element-icon = {
          size = mkLiteral "64px";
          cursor = mkLiteral "inherit";
          background-color = lib.mkForce (mkLiteral "transparent");
        };

        element-text = {
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
          cursor = mkLiteral "inherit";
          background-color = lib.mkForce (mkLiteral "transparent");
        };

        "#textbox-prompt-colon" = {
          expand = false;
          str = ":";
          margin = mkLiteral "0px 0.3em 0em 0em";
          text-color = mkLiteral "@foreground-color";
        };
      };
    };
  };
}
