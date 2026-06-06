{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure starship for shell";
  };

  config = mkIf moduleConfig.enable {
    programs.starship = {
      enable = true;

      settings = {
        format = ''          [($os )](bold blue)$username$hostname$directory$git_branch$git_status$fill$time
          $character'';

        right_format = "";

        fill = {
          symbol = " ";
        };

        username = {
          show_always = true;
          style_user = "bold yellow";
          format = "[Прошу вас, $user]($style)";
        };

        character = {
          success_symbol = "[λ](bold green) ";
          error_symbol = "[λ](bold red) ";
        };

        directory = {
          style = "bold cyan";
          truncation_length = 3;
        };

        time = {
          disabled = false;
          # format = "[[ $time ](grey)]";
          time_format = "%R";
        };

        hostname = {
          ssh_only = false;
          format = "@[$hostname](bold blue) ";
        };

        os = {
          disabled = false;
          symbols = {
            NixOS = " ";
          };
          style = "bold blue";
        };
      };
    };
  };
}
