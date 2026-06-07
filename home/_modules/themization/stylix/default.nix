{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  pkgs,
  ...
}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "Provide stylix global configuration";

    polarity = mkOption {
      type = types.str;
      default = "dark";
      description = "Color polarity for stylix";
    };

    image = mkOption {
      type = types.str;
      description = "Wallpaper image path";
      example = "${pkgs.nixos-artwork.wallpapers.catppuccin-mocha}/share/backgrounds/nixos/nixos-wallpaper-catppuccin-mocha.png";
    };

    imageScalingMode = mkOption {
      type = types.str;
      default = "fill";
    };

    base16Scheme = mkOption {
      type = types.str;
      example = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    };

    fonts = mkOption {
      type = types.attrsOf types.any;
      description = "Font selection for stylix";
      default = {
        monospace = {
          name = "FiraCode Nerd Font";
          package = pkgs.nerd-fonts.fira-code;
        };
        serif = {
          name = "Noto Serif";
          package = pkgs.noto-fonts;
        };
        sansSerif = {
          name = "Noto Sans";
          package = pkgs.noto-fonts;
        };
        emoji = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-color-emoji;
        };
        sizes = {
          applications = 11;
          terminal = 11;
          desktop = 11;
          popups = 11;
        };
      };
    };

    opacity = mkOption {
      type = types.attrsOf types.num;
      default = {
        applications = 1;
        terminal = 0.8;
        desktop = 0.9;
        popups = 0.8;
      };
    };

    cursor = mkOption {
      type = types.attrsOf types.any;
      default = {
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "catppuccin-mocha-dark-cursors";
        size = 32;
      };
    };
  };

  config = mkIf moduleConfig.enable {
    stylix = {
      enable = true;
      polarity = moduleConfig.polarity;
      image = moduleConfig.image or "${pkgs.nixos-artwork.wallpapers.catppuccin-mocha}/share/backgrounds/nixos/nixos-wallpaper-catppuccin-mocha.png";
      imageScalingMode = moduleConfig.imageScalingMode or "fill";
      base16Scheme = moduleConfig.base16Scheme or "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      fonts = moduleConfig.fonts;
      opacity = moduleConfig.opacity;
      cursor = moduleConfig.cursor;
    };
  };
}
