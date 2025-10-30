{
  lib,
  pkgs,
  roles ? {},
  ...
}: {
  config = lib.mkMerge [
    # Base gaming setup
    (lib.mkIf (roles.gaming.enable or false) {
      home.packages = with pkgs; [
        # Gaming utilities
        # mangohud # Performance overlay
        # gamemode # Performance optimization
        # gamescope # Microcompositor
      ];
    })

    # Steam
    (lib.mkIf ((roles.gaming.enable or false) && (roles.gaming.steam or false)) {
      home.packages = with pkgs; [
        steam
        # steam-run
      ];
    })

    # Emulation
    (lib.mkIf ((roles.gaming.enable or false) && (roles.gaming.emulation or false)) {
      home.packages = with pkgs; [
        # retroarch
        # Additional emulators as needed
      ];
    })

    # Game development
    (lib.mkIf ((roles.gaming.enable or false) && (roles.gaming.development or false)) {
      home.packages = with pkgs; [
        godot_4 # Game engine
        # unity
        # blender
      ];
    })

    # Minecraft
    (lib.mkIf ((roles.gaming.enable or false) && (roles.gaming.minecraft or false)) {
      home.packages = with pkgs; [
        prismlauncher # Minecraft launcher
      ];
    })
  ];
}
