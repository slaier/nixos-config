{ super, modules, ... }:
with super.lib;
(collectBlock "overlay" modules) // { lib = final: prev: super.lib; }
