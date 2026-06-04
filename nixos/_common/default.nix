{...}: {
  time.timeZone = "Europe/Moscow";

  modules.boot.silent = {
    enable = true;
    plymouth = true;
  };

  modules.audio = {
    low-latency.enable = true;
    disable-hsp-hfp.enable = true;
    noise-suppression.enable = true;
  };
}
