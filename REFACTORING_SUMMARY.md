# Home Manager Modules Refactoring Summary

## Overview

This refactoring introduces shared home-manager modules that can be used across multiple users, reducing duplication and improving maintainability. The Eugene user configuration has been refactored to use these modules as a proof of concept.

## What Was Created

### New Directory: `home-modules/`

A collection of reusable, user-agnostic home-manager modules:

1. **terminal.nix** - Terminal utilities (ripgrep, fd, fzf, htop, etc.)
2. **editors.nix** - Text editors and language servers
3. **git.nix** - Git configuration with comprehensive aliases
4. **desktop-base.nix** - Core desktop utilities
5. **desktop-gnome.nix** - GNOME-specific tools
6. **desktop-xmonad.nix** - XMonad window manager setup
7. **desktop-apps.nix** - Desktop applications (browsers, productivity, communication)
8. **multimedia.nix** - Audio/video tools
9. **gaming.nix** - Gaming platforms and utilities
10. **communication.nix** - Chat and communication apps
11. **development-base.nix** - Development tools and language runtimes

### Documentation

- **home-modules/README.md** - Usage guide for shared modules
- **home/eugene/MIGRATION.md** - Detailed migration documentation for Eugene's config

## Changes to Eugene's Configuration

### Before
- Flat package list with ~40 packages in `default.nix`
- Minimal git configuration
- Empty SSH configuration
- Basic program setup

### After
- Role-based configuration using shared modules
- Comprehensive git setup with aliases and difftastic
- GitHub CLI integration
- Proper editor configuration with language servers
- XMonad properly configured via shared module
- Only user-specific packages remain (hledger, exfat, zlib)

### File Changes
- ✏️ Modified: `home/eugene/default.nix` - Now uses roles and shared modules
- ✏️ Modified: `home/eugene/common.nix` - Simplified, proper SSH config
- ✏️ Modified: `home/eugene/programs/default.nix` - Removed git import
- 🗑️ Removed: `home/eugene/ssh.nix` - Integrated into common.nix
- 📦 Backed up: `home/eugene/programs/git/` → `git.bak/`
- 📦 Backed up: `home/eugene/modules/xmonad.nix` → `xmonad.nix.bak`

## Benefits

### 1. Reduced Duplication
- Common packages defined once in shared modules
- Both clord and eugene can use the same base configuration
- Future users can reuse these modules

### 2. Better Organization
- Packages grouped by functionality
- Clear separation of concerns
- Role-based enable flags

### 3. Easier Maintenance
- Fix a bug once, benefits all users
- Update packages in one place
- Consistent configuration across users

### 4. Bug Fixes for Eugene
- **Git**: Added comprehensive alias set, better merge handling, difftastic
- **GitHub CLI**: Properly configured with SSH
- **Editors**: Language servers, formatters, linters now available
- **SSH**: Proper configuration structure
- **XMonad**: All required utilities (dmenu, nitrogen, feh, etc.)

### 5. Improved Consistency
- Both users now have similar structure
- Easier to understand and navigate
- Better adherence to DRY principle

## Architecture

### Role System

Modules use a consistent role-based pattern:

```nix
roles = {
  terminal.enable = true;
  editors.enable = true;
  git.enable = true;
  desktop = {
    enable = true;
    windowManager = "xmonad" | "gnome";
    productivity = true;
    browsers = true;
    communication = true;
  };
  development = {
    enable = true;
    languages = {
      go = true;
      python = true;
      rust = false;
      # etc.
    };
  };
  multimedia = {
    enable = true;
    video = true;
    audio = true;
    graphics = false;
  };
  gaming = {
    enable = true;
    steam = true;
    emulation = false;
    minecraft = true;
    development = true;
  };
}
```

### User-Specific Overrides

Users can override shared defaults:

```nix
programs.git = {
  userName = "Your Name";
  userEmail = "your@email.com";
};

programs.alacritty.settings.font.size = 14;
```

## Comparison with Clord's Modules

### Clord's Modules (`home/clord/modules/`)
- User-specific (tailored for clord's needs)
- Include Grafana and Kubernetes tools
- Tied to clord's workflow

### Shared Modules (`home-modules/`)
- User-agnostic
- General-purpose functionality
- Can be used by any user

### Relationship
- Shared modules handle common functionality
- Clord's specific modules add specialized features
- Eugene now uses shared modules
- Clord could potentially adopt some shared modules too

## Migration Path for Other Users

To migrate a new user to shared modules:

1. Create user directory in `home/<username>/`
2. Import `../../home-modules` in `default.nix`
3. Configure roles based on user needs
4. Override user-specific settings (git name/email, etc.)
5. Add any user-specific packages not covered by modules

## Testing

Before deploying to a live system:

```bash
# Check flake syntax
nix flake check

# Build without activating (for NixOS)
nixos-rebuild build --flake .#wildwood

# Test in a VM
nixos-rebuild build-vm --flake .#wildwood
```

## Future Improvements

### Short Term
1. Test the refactored eugene config on wildwood
2. Fix any issues that arise
3. Consider migrating clord to use some shared modules

### Long Term
1. Create more granular role options
2. Add conditional package options (e.g., browser choice)
3. Develop system-wide shared modules (not just home-manager)
4. Consider moving some of clord's modules to shared (if generic enough)
5. Add more language support to development module

## Rollback Plan

If issues arise:

1. **Eugene's config**: Restore from git history
   ```bash
   git checkout HEAD~1 -- home/eugene/
   ```

2. **Old configs backed up as**:
   - `home/eugene/programs/git.bak/`
   - `home/eugene/modules/xmonad.nix.bak`

3. **Remove shared modules**:
   ```bash
   git rm -rf home-modules/
   ```

## Notes

- All old configurations are preserved as backups
- Changes are backward compatible for clord
- Eugene's xmonad.hs is unchanged
- No system-level changes were made
- This is purely a home-manager refactoring

## Acknowledgments

This refactoring follows the patterns established in clord's configuration but makes them more general and reusable. It maintains the philosophy of declarative, reproducible configuration while reducing duplication.
