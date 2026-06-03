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
}