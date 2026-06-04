{...}: {
  # стирка при загрузке
  modules.boot.impermanence = {
    enable = true;
    volumes = [
      {
        device = "/dev/disk/by-partlabel/disk-main-root";
        blankSubvolume = "@blank";
        subvolume = "@";
      }
    ];
  };

  modules.space.disko = {
    enable = true;

    bootDisk = {
      device = "/dev/nvme0n1";
      isSsd = true;

      dualbootWindows = {
        enable = true;
        size = "128G";
        recoveryCreate = true;
      };

      systemBtrfsPartition = {
        createPersistSubvol = true;
        swapFile = "8G";
        homes = ["artemos"];
      };
    };
  };
}
