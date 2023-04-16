default: (local "test")

local goal="switch":
  colmena apply-local --sudo {{goal}}

n1 goal="switch":
  colmena apply --on n1 --no-substitutes {{goal}}

build nodes="local,n1":
  colmena build --on {{nodes}}

apply goal="switch": build (local goal) (n1 goal)
