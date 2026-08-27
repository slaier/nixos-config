default: (local "test")

# Fast, no-sudo validation: evaluate the `local` config and print what would
# be built. Use this instead of `just` to verify changes without a password or
# system activation. Requires new files to be `git add`ed first (Nix can't see
# untracked paths — the dry-run will name the untracked path if so).
check:
  nix build .#nixosConfigurations.local.config.system.build.toplevel --dry-run

# Build the `local` system closure to ./result without activating (no sudo).
build:
  nix build .#nixosConfigurations.local.config.system.build.toplevel

local goal="switch" *FLAGS="":
  sudo nixos-rebuild {{goal}} --flake .#local {{FLAGS}}

rollback:
  sudo nixos-rebuild test --flake .#local --rollback

iso:
  nix build .#nixosConfigurations.installer.config.system.build.isoImage

update:
  nix flake update
  nix-update CloudflareSpeedTest --flake
  nix-update mattpocock-skills --flake
  nix-update pw-duck --flake
  nix-update free-claude-code --flake -u
  nix-update excel-mcp-server --flake
