let
  installerKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMKnsYHS7klJxGAFGoz8cELMZnLn3dXnwoJEhn4eGQir artemos@SHIZZA";
in {
  "mihomo.yaml.age".publicKeys = [installerKey];
}
