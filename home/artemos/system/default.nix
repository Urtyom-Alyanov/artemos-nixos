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
      "podman"
    ];

    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };
}
