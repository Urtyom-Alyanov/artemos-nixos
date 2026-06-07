{
  mkOptions,
  moduleConfig,
  ...
}: {
  lib,
  config,
  ...
}:
with lib; let
  blockHeader = name:
    if hasPrefix "Host " name || hasPrefix "Match " name
    then name
    else "Host ${name}";
in {
  options = mkOptions {
    enable = mkEnableOption "configure fastfetch";
    identityFileAgeEncrypted = mkOption {
      type = types.path;
      description = "Age encrypted file with SSH identity key for SSH daemon";
    };
    settings = mkOption {
      type = lib.hm.types.dagOf (
        types.submodule (
          {dagName, ...}: {
            freeformType = types.attrsOf types.anything;
            options.header = mkOption {
              type = types.str;
              default = blockHeader dagName;
              defaultText = lib.literalMD ''
                The attribute name, prefixed with `Host ` unless it already
                starts with `Host ` or `Match `.
              '';
              description = ''
                The literal `Host` or `Match` line that opens this block.

                By default this is derived from the attribute name: names
                starting with `Host ` or `Match ` are used literally, and
                all other names are prefixed with `Host `. This default is
                suitable for most configurations.

                Set this only when the header cannot be expressed as the
                attribute name, e.g. when it carries Nix string context
                (store paths), or when a stable attribute name is wanted
                for {option}`lib.hm.dag` ordering.
              '';
            };
          }
        )
      );
      default = {};
      example = literalExpression ''
        {
          "github.com" = {
            HostName = "github.com";
            User = "git";
            IdentityFile = "~/.ssh/github";
          };

          "Host *.example.org" = lib.hm.dag.entryBefore [ "github.com" ] {
            IdentityFile = "~/.ssh/example";
            LocalForward = [
              {
                bind.port = 8080;
                host.address = "10.0.0.13";
                host.port = 80;
              }
              "9000 10.0.0.2:90"
            ];
            DynamicForward = "127.0.0.1:1080";
          };

          "Match host *.corp exec \"test -f ~/.corp\"" = {
            ProxyJump = "bastion";
            RemoteForward = {
              bind.port = 8081;
              host.address = "10.0.0.14";
              host.port = 80;
            };
          };
        }
      '';
      description = ''
        OpenSSH client configuration blocks written to
        {file}`~/.ssh/config`.

        Attribute names are interpreted as `Host` patterns unless they
        start with `Host ` or `Match `, in which case they are written
        literally as block headers. If the order of rules matter then
        use the DAG functions to express the dependencies as shown in
        the example.

        See
        {manpage}`ssh_config(5)`
        for more information.
      '';
    };
  };

  config = mkIf moduleConfig.enable {
    age.secrets.ssh-key = {
      file = moduleConfig.identityFileAgeEncrypted;
      mode = "0600";
    };

    services.ssh-agent.enable = true;

    programs.ssh = {
      enableDefaultConfig = false;
      enable = true;

      settings =
        {
          "*" = {
            IdentityFile = config.age.secrets.ssh-key.path;
          };

          "github.com" = {
            HostName = "github.com";
            User = "git";
          };

          "Host git.*" = {
            User = "git";
          };
        }
        // moduleConfig.settings;
    };
  };
}
