{ self, ... }:
{
  flake.diskoConfigurations = {
    inherit (self.diskoConfig) hermes persephone;
  };
}
