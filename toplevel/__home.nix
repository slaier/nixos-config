{ inputs, ... }:
users:
{
  home-manager = {
    inherit users;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
