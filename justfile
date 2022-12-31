default: pc

pc:
  sudo nixos-rebuild --flake .#pc switch

n1:
  colmena build --on n1
  colmena apply --on n1 --evaluator streaming --no-substitutes
