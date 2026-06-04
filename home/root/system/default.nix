{hashedDir, ...}: {
  users.users.root.hashedPassword = "${hashedDir}/root-password";
}
