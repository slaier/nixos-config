{ super, ... }:
{
  nixos = {
    imports = map (x: x.home or { }) super.imports;
  };
}
