{lib, ...}: {
  options.roles = {
    terminal = {
      enable = lib.mkEnableOption "terminal utilities and tools";
    };

    editors = {
      enable = lib.mkEnableOption "text editors and language servers";
    };

    git = {
      enable = lib.mkEnableOption "git configuration and tools";
    };

    desktop = {
      enable = lib.mkEnableOption "desktop environment support";

      windowManager = lib.mkOption {
        type = lib.types.enum ["xmonad" "gnome" ""];
        default = "";
        description = "Window manager to configure";
      };

      productivity = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable productivity applications (LibreOffice, etc.)";
      };

      browsers = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable web browsers";
      };

      communication = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable communication applications";
      };
    };

    development = {
      enable = lib.mkEnableOption "development tools";

      languages = {
        go = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Go language support";
        };

        python = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Python language support";
        };

        rust = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Rust language support";
        };

        java = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Java language support";
        };

        racket = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Racket language support";
        };

        node = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Node.js language support";
        };

        zig = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Zig language support";
        };
      };
    };

    multimedia = {
      enable = lib.mkEnableOption "multimedia tools";

      video = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable video tools (OBS, media players, etc.)";
      };

      audio = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable audio tools (Audacity, etc.)";
      };

      graphics = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable graphics tools (GIMP, Inkscape, etc.)";
      };
    };

    gaming = {
      enable = lib.mkEnableOption "gaming support";

      steam = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Steam platform";
      };

      emulation = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable game emulation";
      };

      minecraft = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Minecraft (PrismLauncher)";
      };

      development = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable game development tools (Godot, etc.)";
      };
    };

    communication = {
      enable = lib.mkEnableOption "communication applications";
    };

    onepassword = {
      enable = lib.mkEnableOption "1Password password manager";
    };
  };
}
