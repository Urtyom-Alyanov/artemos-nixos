{hashedDir, ...}: {
  users.users.root.hashedPasswordFile = "${hashedDir}/root-password";
}
