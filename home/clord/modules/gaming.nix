{
  lib,
  pkgs,
  roles,
  ...
}: {
  config = lib.mkMerge [
    # Base gaming setup
    (lib.mkIf roles.gaming.enable {
      home.packages = with pkgs; [
        # Core gaming utilities
        mangohud # Performance overlay
        gamemode # Performance optimization daemon
        gamescope # Microcompositor for gaming

        # Additional gaming tools (commented out - uncomment as needed):
        # lutris           # Open gaming platform
        # wine-staging     # Windows compatibility layer
        # winetricks       # Wine helper scripts
        # protontricks     # Proton helper for Steam games
        # heroic           # Epic Games Launcher
        # bottles          # Wine prefix manager
        # antimicrox       # Gamepad to keyboard/mouse mapping
        # xpadneo          # Xbox controller driver
      ];
    })

    # Steam platform
    (lib.mkIf (roles.gaming.enable && roles.gaming.steam) {
      home.packages = with pkgs; [
        steam
        # steam-run        # Run non-Steam games in Steam environment
      ];
    })

    # Emulation platform
    (lib.mkIf (roles.gaming.enable && roles.gaming.emulation) {
      home.packages = with pkgs; [
        retroarch # Multi-system emulator

        # Additional emulators (commented out - uncomment as needed):
        # dolphin-emu      # GameCube/Wii
        # pcsx2            # PlayStation 2
        # rpcs3            # PlayStation 3
        # ppsspp           # PlayStation Portable
        # cemu             # Wii U
        # yuzu             # Nintendo Switch
        # desmume          # Nintendo DS
        # mgba             # Game Boy Advance
        # snes9x           # Super Nintendo
        # mupen64plus      # Nintendo 64
      ];
    })
  ];
}
