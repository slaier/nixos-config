default: local

local:
  colmena apply-local --sudo

n1:
  colmena apply --on n1 --no-substitutes

build:
  colmena build

apply: build local n1
