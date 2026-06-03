{ ... }: {
  # невидия драйвера
  modules.video.nvidia = {
    enable = true;
    useLibVADriver = true;
    earlyProbe = true;
    openDrivers = true;
  };
}