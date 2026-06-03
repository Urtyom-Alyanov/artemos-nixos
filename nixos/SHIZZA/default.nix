{ ... }: {
  # невидия драйвера
  modules.video.nvidia = {
    enable = true;
    useLibVADriver = true;
    earlyProbe = true;
    openDrivers = true;
  };

  # стирка при загрузке
  modules.boot.impermanence = {
    enable = true;
    volumes = [
      {
        device = "/dev/disk/by-partlabel/disk-main-root";
        blankSubvolume = "@blank";
        subvolume = "@";
      }
      {
        device = "/dev/disk/by-partlabel/disk-home-artemos";
        blankSubvolume = "@blank";
        subvolume = "@";
      }
    ];
  };
}