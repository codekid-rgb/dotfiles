# Shared Home Manager Modules

This directory contains reusable home-manager modules that can be shared across multiple users (clord, eugene, etc.). These modules provide role-based configuration similar to the clord-specific modules but are designed to be user-agnostic.

## Philosophy

- **User-agnostic**: Modules should not hardcode user-specific values (names, emails, etc.)
- **Role-based**: Use enable flags to control what gets installed
- **Composable**: Modules can be mixed and matched based on needs
- **DRY**: Avoid duplication between user configurations

## Available Modules

### Core Modules

- **terminal.nix**: Basic terminal utilities (ripgrep, fd, fzf, htop, etc.)
- **editors.nix**: Text editors and related tools (nvim, helix, language servers)
- **git.nix**: Git configuration template (override user details per user)

### Desktop Modules

- **desktop-base.nix**: Core desktop utilities (file managers, system tools)
- **desktop-gnome.nix**: GNOME-specific tools and configuration
- **desktop-xmonad.nix**: XMonad window manager setup
- **desktop-apps.nix**: Common desktop applications

### Development Modules

- **development-base.nix**: Core development tools
- **development-languages.nix**: Programming language toolchains

### Specialized Modules

- **multimedia.nix**: Audio/video tools (audacity, obs, vlc, etc.)
- **gaming.nix**: Gaming platforms and utilities
- **communication.nix**: Chat and communication apps

## Usage

In your user's home configuration:

```nix
{
  imports = [
    ../../home-modules
  ];

  # Configure roles
  roles = {
    terminal.enable = true;
    editors.enable = true;
    desktop = {
      enable = true;
      windowManager = "xmonad"; # or "gnome"
    };
    development.enable = true;
    gaming.enable = false;
  };

  # Override user-specific settings
  programs.git = {
    userName = "Your Name";
    userEmail = "your@email.com";
  };
}
```

## Migration Notes

- Eugene's configuration will be refactored to use these modules
- Clord's user-specific modules remain in `home/clord/modules/`
- This reduces duplication and makes it easier to maintain consistency
