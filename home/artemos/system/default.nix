{...}: {
  users.users.artemos = {
    isNormalUser = true;
    uid = 1000;
    description = "Артём Клочков";
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "input"
      "dialout"
      "adbusers"
      "scanner"
      "lp"
    ];
  };
}
