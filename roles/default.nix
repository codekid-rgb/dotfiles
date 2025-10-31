{lib, ...}: {
  options.roles = {
    terminal.enable = lib.mkEnableOption "Terminal and shell tools";

    development = {
      enable = lib.mkEnableOption "General development tools";
      languages = {
        go = lib.mkEnableOption "Go development";
        rust = lib.mkEnableOption "Rust development";
        node = lib.mkEnableOption "Node.js development";
        python = lib.mkEnableOption "Python development";
        zig = lib.mkEnableOption "Zig development";
      };
    };

    kubernetes = {
      enable = lib.mkEnableOption "Kubernetes tools";
      includeHelm = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include Helm package manager";
      };
      includeK9s = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include k9s terminal UI";
      };
    };

    grafana = {
      enable = lib.mkEnableOption "Grafana development setup";
      includeCloud = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Include Grafana Cloud tools";
      };
    };

    desktop = {
      enable = lib.mkEnableOption "Desktop environment and GUI apps";
      browsers = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include web browsers";
      };
      communication = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include communication apps (Slack, Discord, etc)";
      };
      productivity = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include productivity tools (office suite, PDF viewers, etc)";
      };
      windowManager = lib.mkOption {
        type = lib.types.enum ["none" "xmonad" "gnome"];
        default = "none";
        description = "Window manager to use (none, xmonad, gnome)";
      };
    };

    gaming = {
      enable = lib.mkEnableOption "Gaming tools and platforms";
      steam = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include Steam gaming platform";
      };
      emulation = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Include RetroArch and emulation tools";
      };
    };

    multimedia = {
      enable = lib.mkEnableOption "Multimedia editing and creation tools";
      video = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include video editing and playback tools";
      };
      audio = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include audio editing and playback tools";
      };
      graphics = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Include image/graphics editing tools";
      };
    };

    server = {
      enable = lib.mkEnableOption "Server and infrastructure tools";
    };

    autoUpdate = {
      enable = lib.mkEnableOption "Automatic dotfiles updates on boot";
      periodic = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable periodic (daily) updates in addition to boot updates";
      };
    };
  };

  config = {};
}
