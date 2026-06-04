{hashedDir, ...}: {
  users.users.artemos = {
    isNormalUser = true;
    uid = 1000;
    hashedPasswordFile = "${hashedDir}/artemos-password";
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
