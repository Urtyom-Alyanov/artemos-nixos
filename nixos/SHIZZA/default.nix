{...}: {
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

  modules.space.disko = {
    enable = true;

    bootDisk = {
      device = "/dev/sda";
      isSsd = true;
      dualbootWindows = {
        enable = true;
        size = "128G";
        recoveryCreate = true;
      };
      systemBtrfsPartition = {
        createPersistSubvol = true;
        swapFile = "8G";
      };
    };

    homeDisks."artemos" = {
      device = "/dev/sdb";
      isSsd = false;
      createPersistSubvol = true;
    };
  };
}
