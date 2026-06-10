{
  mkOptions,
  moduleConfig,
  ...
}: {lib, ...}:
with lib; {
  options = mkOptions {
    enable = mkEnableOption "configure ssh service options";
    agent = mkOption {
      type = types.enum ["none" "openssh" "gnome" "gpg"];
      default = "none";
      description = "Choose SSH agent";
    };
  };

  config = mkIf moduleConfig.enable {
    services.openssh.enable = true;
    programs.ssh = {
      startAgent = mkForce (moduleConfig.agent == "openssh");
    };

    services.gnome.gcr-ssh-agent.enable = mkForce (moduleConfig.agent == "gnome");
    programs.gnupg.agent.enableSSHSupport = mkForce (moduleConfig.agent == "gpg");
  };
}
