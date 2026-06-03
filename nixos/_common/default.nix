{...}: {
  time.timeZone = "Europe/Moscow";

  modules.boot.silent = {
    enable = true;
    plymouth = true;
  };
}