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
    enable = mkEnableOption "use qemu/kvm for virtual machines";
    enableVirtManager = mkEnableOption "use virt manager ui for qemu";
    fullCompatPkg = mkEnableOption "use qemu_full instead of qemu_kvm";
  };

  config = mkIf moduleConfig.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package =
          if moduleConfig.fullCompatPkg
          then pkgs.qemu_full
          else pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    virtualisation.spiceUSBRedirection.enable = true;

    programs.virt-manager.enable = moduleConfig.enableVirtManager;
  };
}
