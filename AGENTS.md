# AGENTS.md

Compact guidance for OpenCode sessions in this NixOS flake repo. Full module
rules live in `CLAUDE.md` — read it too. This file only captures the
non-obvious facts an agent is likely to miss.

## Commands

- `just check` — fast, no-sudo validation: evaluates the `local` config and prints what would be built (`nix build .#nixosConfigurations.local.config.system.build.toplevel --dry-run`). **Use this to verify changes instead of `just`** — it needs no password and doesn't activate the system. Requires new/untracked files to be `git add`ed first (Nix can't see untracked paths; the dry-run names the offending path).
- `just build` — build the `local` system closure to `./result` without activating (no sudo).
- `just` — build & activate the `local` config (`sudo nixos-rebuild test --flake .#local`). Only needed when you actually want to apply the config; otherwise prefer `just check`.
- `just local switch` / `just local boot` / `just rollback` — activate / set next-boot / revert.
- `just iso` — build the installer ISO.
- `just update` — `nix flake update` + `nix-update` for each pinned package; `free-claude-code` uses `-u` (custom `passthru.updateScript`). Do not hand-edit the version/sha in its `package.nix`. For new `fetchurl` hashes use `hash = lib.fakeHash` initially and let the build failure report the correct `sha256-...`, instead of manually running `nix-prefetch-url`.
- `just check-ascii` — verify no Chinese characters in `modules/`, `justfile`, etc. (code must be English only, no Chinese). This is run automatically by `just check`.
- `nix build .#<leaf-dir-name>` — build a single package. Package attrs are flattened to the package's **parent directory name** (e.g. `free-claude-code`), despite arbitrary nesting under `modules/`.
- `nix fmt` — formatter is `nixfmt-tree`. Run before committing or CI lint fails.

## Module auto-discovery (highest-signal gotcha)

`lib/fromDirectoryRecursive` walks `modules/` recursively and only picks up
**exact filenames**: `default.nix` (NixOS module), `home.nix` (Home Manager),
`package.nix`, `packages.nix`, `overlay.nix`.

- Any other filename is **silently ignored** — a module you add won't load unless the file is named exactly one of these.
- Directories prefixed with `_` are skipped.
- A `package.nix` is auto-wrapped as an overlay under `pkgs.<parent-dir-name>` (guarded by `assert !(lib.hasAttr name prev)`). A module's NixOS/Home config can reuse it directly as `pkgs.<name>`; name collisions with existing `pkgs` attrs are forbidden.

## Secrets

- Encrypted with sops-nix. Add/replace via `sops secrets/secrets.yaml`; reference in config with `sops.secrets.<name>`.
- Decrypt to inspect: `sops --decrypt secrets/secrets.yaml`. Age key is in `.sops.yaml`.

## Structure

- `modules/` — program configs needing setup (each dir = one feature).
- `hosts/local/` — the live host (`hardware-configuration.nix` + simple system packages). `hosts/installer/` — minimal ISO.
- `flake.nix` — entry; wires modules via `_module.args.inputs` (access as `inputs` in modules). `stateVersion = "26.05"`.
- Two configs: `local` (full desktop) and `installer` (ISO).

## Environment quirks

- Nix `experimental-features` is `"cgroups nix-command flakes"` (note `cgroups`, not just `nix-command flakes`); `use-cgroups = true`. Keep this if running nix manually.
- Proxy at `http://local.lan:7890`; substituters include `slaier.cachix.org` and `nix-community.cachix.org`.
- CI runs on the `develop` branch (not `main`).
