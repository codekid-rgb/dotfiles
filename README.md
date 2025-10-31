# clord's dotfiles

A comprehensive Nix-based configuration for managing macOS and NixOS systems using flakes, home-manager, and nix-darwin.

## 📁 Structure

```
├── flake.nix           # Main flake configuration
├── home/               # User configurations (home-manager)
│   ├── clord/          # Primary user
│   │   ├── packages/   # Package organization
│   │   └── programs/   # Program configurations
│   └── eugene/         # Secondary user
├── systems/            # System-level configurations
├── nixos-modules/      # Reusable NixOS modules
├── roles/              # System roles/features
├── secrets/            # Encrypted secrets (agenix)
├── pubkeys/            # Public SSH keys
└── Makefile            # Build commands
```

## 🚀 Quick Start

### Prerequisites

1. Install Nix with flakes support:
```bash
# macOS
sh <(curl -L https://nixos.org/nix/install)

# Enable flakes
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

2. Clone this repository:
```bash
git clone https://github.com/clord/dotfiles.git
cd dotfiles
```

### Installation

#### macOS (nix-darwin)
```bash
# First time setup
nix run nix-darwin -- switch --flake .#$(hostname)

# Subsequent updates
make darwin-switch
```

#### NixOS
```bash
# Apply configuration
sudo nixos-rebuild switch --flake .#$(hostname)

# Or use make
make nixos-switch
```

## 🛠️ Development

### Enter Development Shell
```bash
# Manual
nix develop

# With direnv (recommended)
direnv allow
```

### Available Development Commands
```bash
# Format all Nix files
nix fmt

# Run all checks
nix flake check

# Check for issues
nix develop -c statix check    # Static analysis
nix develop -c deadnix .        # Find unused code
nix develop -c alejandra .      # Format code

# Update dependencies
nix flake update
```

## 💻 Supported Systems

### macOS
- **waba** - Work MacBook (M-series)
- **edmon** - Personal MacBook (M-series)

### NixOS
- **wildwood** - Desktop workstation (x86_64)
- **dunbar** - Server (aarch64)
- **chickenpi** - Raspberry Pi (aarch64)

## 🔑 Secret Management

Secrets are managed using [agenix](https://github.com/ryantm/agenix):

```bash
# Re-encrypt secrets after adding new keys
make rekey

# Edit a secret
cd secrets && agenix -e secret-name.age
```

## 📦 Package Organization

Packages are organized for better maintainability:
- `home/clord/packages/common.nix` - Shared packages for all systems
- `home/clord/packages/darwin.nix` - macOS-specific packages
- `home/clord/packages/linux.nix` - Linux-specific packages

## 🔧 Customization

### Adding a New System
1. Create `systems/<hostname>.nix`
2. Add configuration to `flake.nix`
3. Create home configuration in `home/<username>/<hostname>.nix`
4. Run `nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel`

### Adding Packages
- For all systems: Edit `home/clord/packages/common.nix`
- For macOS only: Edit `home/clord/packages/darwin.nix`
- For Linux only: Edit `home/clord/packages/linux.nix`

## 📝 Documentation

- [CLAUDE.md](./CLAUDE.md) - Detailed project context and architecture
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Learn Nix basics
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/)

## 🤝 Acknowledgments

Inspired by:
- [rprospero/dotfiles](https://gitlab.com/rprospero/dotfiles/)
- [thexyno/nixos-config](https://github.com/thexyno/nixos-config)
- [calops/nix](https://github.com/calops/nix)

## 📋 TODO

- [ ] Implement CI/CD with GitHub Actions
- [ ] Add pre-commit hooks
- [ ] Improve modularization of roles
- [ ] Add more documentation per module
- [ ] Set up Homelab server configurations
- [ ] Complete Grafana development setup
- [ ] Fix the GNOME Extension Issues
- [ ] Add Thereien using extended GNOME
