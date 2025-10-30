{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkMerge [
    # Base gaming setup
    (lib.mkIf config.roles.gaming.enable {
      home.packages = with pkgs; [
        # Gaming utilities
        # mangohud # Performance overlay
        # gamemode # Performance optimization
        # gamescope # Microcompositor
      ];
    })

    # Steam
    (lib.mkIf (config.roles.gaming.enable && config.roles.gaming.steam) {
      home.packages = with pkgs; [
        steam
        # steam-run
      ];
    })

    # Emulation
    (lib.mkIf (config.roles.gaming.enable && config.roles.gaming.emulation) {
      home.packages = with pkgs; [
        # retroarch
        # Additional emulators as needed
      ];
    })

    # Game development
    (lib.mkIf (config.roles.gaming.enable && config.roles.gaming.development) {
      home.packages = with pkgs; [
        godot_4 # Game engine
        # unity
        # blender
      ];
    })

    # Minecraft
    (lib.mkIf (config.roles.gaming.enable && config.roles.gaming.minecraft) {
      home.packages = with pkgs; [
        prismlauncher # Minecraft launcher
      ];
    })
  ];
}
