{pkgs, ...}: {
  imports = [
    ./common.nix
    ./programs
    ../../home-modules # Import shared modules
  ];

  # Configure roles based on Eugene's needs
  roles = {
    # Core functionality
    terminal.enable = true;
    editors.enable = true;
    git.enable = true;

    # Desktop setup
    desktop = {
      enable = true;
      windowManager = ""; # XMonad disabled for now
      productivity = true;
      browsers = true;
      communication = true;
    };

    # Development
    development = {
      enable = true;
      languages = {
        go = true;
        python = true;
        java = true;
        racket = true;
        rust = false;
      };
    };

    # Multimedia
    multimedia = {
      enable = true;
      video = true;
      audio = true;
      graphics = false;
    };

    # Gaming
    gaming = {
      enable = true;
      steam = true;
      minecraft = true;
      development = true; # Godot
      emulation = false;
    };
  };

  # XMonad configuration
  xsession.windowManager.xmonad.config = ./xmonad.hs;

  # Program configurations
  programs = {
    # Git user configuration (override shared defaults)
    git = {
      userName = "Eugene Lord";
      userEmail = "eugene@lord.ac";

      # Enable difftastic for better diffs
      difftastic.enable = true;
    };

    # GitHub CLI configuration
    gh = {
      enable = true;
      settings = {
        version = 1;
        git_protocol = "ssh";
        editor = "nvim";
      };
    };

    # Override alacritty font size (from eugene's original config)
    alacritty.settings.font.size = 14;

    # Enable programs that were explicitly configured before
    neovim.enable = true;
    vscode.enable = true;
    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
  };

  # Additional packages not covered by modules
  home.packages = with pkgs; [
    # Finance/accounting
    hledger

    # File systems
    exfat

    # System utilities
    zlib
  ];

  systemd.user.startServices = "sd-switch";
}
