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
    enable = mkEnableOption "configure helix editor";
  };

  config = mkIf moduleConfig.enable {
    programs.helix = {
      enable = true;
      package = pkgs.helix;

      settings = {
        editor = {
          line-number = "relative";
          mouse = true;
          cursorline = true;
          bufferline = "always";
          auto-format = true;
          idle-timeout = 200;

          cursor-shape = {
            insert = "bar";
            normal = "block";
          };

          lsp.display-messages = true;

          indent-guides = {
            render = true;
            charaster = "|";
          };

          statusline = {
            left = [
              "file-name"
              "spinner"
            ];
            center = [
              "mode"
              "version-control"
            ];
            right = [
              "diagnostics"
              "selections"
              "position"
              "file-encoding"
            ];

            mode = {
              insert = "WRITING";
              normal = "READING";
              select = "SELECTING";
            };
          };
        };
      };
    };
  };
}
