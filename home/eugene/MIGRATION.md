# Eugene User Configuration Migration

This document describes the migration of Eugene's user configuration to use shared home-manager modules.

## Changes Made

### Structure
- **Before**: Flat package list with ~40 packages directly in `default.nix`
- **After**: Role-based configuration using shared modules from `../../home-modules`

### Benefits
1. **Better organization**: Packages are now grouped by functionality (terminal, editors, desktop, etc.)
2. **Reduced duplication**: Shares common configuration with clord and future users
3. **Easier maintenance**: Changes to common tools benefit all users
4. **Bug fixes**: Improved git configuration, proper SSH setup, consistent editor config

## Role Configuration

Eugene now uses these roles:

```nix
roles = {
  terminal.enable = true;        # Terminal utilities (ripgrep, fd, fzf, etc.)
  editors.enable = true;          # Editors (nvim, helix) and language servers
  git.enable = true;              # Git with sensible defaults and aliases

  desktop = {
    enable = true;
    windowManager = "xmonad";     # XMonad WM with required utilities
    productivity = true;          # LibreOffice, Typst, etc.
    browsers = true;              # Floorp browser
    communication = true;         # Discord
  };

  development = {
    enable = true;
    languages = {
      go = true;
      python = true;
      java = true;
      racket = true;
    };
  };

  multimedia = {
    enable = true;
    video = true;                 # OBS, Plex
    audio = true;                 # Audacity, ALSA utils
  };

  gaming = {
    enable = true;
    steam = true;
    minecraft = true;             # PrismLauncher
    development = true;           # Godot 4
  };
}
```

## Package Mapping

### Moved to Shared Modules

- **Terminal utilities** → `home-modules/terminal.nix`
  - eza, fd, ripgrep, fzf, htop, killall, etc.

- **Editors** → `home-modules/editors.nix`
  - neovim, vim, nano, language servers, formatters

- **Git** → `home-modules/git.nix`
  - Comprehensive git configuration with aliases
  - GitHub CLI integration
  - Difftastic for better diffs

- **Desktop apps** → `home-modules/desktop-*.nix`
  - XMonad utilities (dmenu, nitrogen, feh, trayer)
  - File managers (nautilus, dolphin)
  - Terminal emulators (alacritty, terminator, konsole)
  - Productivity tools (LibreOffice, Typst)
  - Browser (floorp)

- **Development** → `home-modules/development-base.nix`
  - gcc, gnumake, jdk17, python, go, racket

- **Multimedia** → `home-modules/multimedia.nix`
  - audacity, obs-studio, plex-media-player, alsa-utils

- **Gaming** → `home-modules/gaming.nix`
  - steam, prismlauncher, godot_4

### Kept in Eugene's Config

Only truly user-specific packages remain:
- hledger (personal finance)
- exfat (file system support)
- zlib (system library)

### Removed/Deprecated

- `home/eugene/programs/git/` → Replaced by shared git module
- `home/eugene/modules/xmonad.nix` → Replaced by shared xmonad module
- `home/eugene/ssh.nix` → Integrated into common.nix
- Firefox → Still disabled due to hash collision

## Improvements

### Git Configuration
- Added comprehensive alias set (st, lg, br, co, etc.)
- Better merge conflict resolution (zdiff3)
- Automatic push setup
- GitHub CLI integration with SSH
- Difftastic for better diffs

### XMonad Setup
- Properly configured through shared module
- All required utilities (dmenu, nitrogen, feh, etc.)
- Custom xmonad.hs still used

### Editor Configuration
- Global .editorconfig file
- Nix language servers (nixd, nil)
- Code formatters (alejandra, nixfmt)
- Linters (statix, deadnix, shellcheck)

### Terminal Environment
- Modern replacements (eza instead of ls)
- Better search tools (ripgrep, fd)
- System monitoring (btop, htop)

## Rollback

If issues arise, old configurations are backed up as:
- `home/eugene/programs/git.bak/`
- `home/eugene/modules/xmonad.nix.bak`

To rollback, restore these files and revert `default.nix` from git.

## Future Improvements

Potential enhancements:
1. Add SSH key management with proper host configurations
2. Enable more GNOME apps if needed
3. Consider adding more language servers for development
4. Set up proper backup/sync solutions
