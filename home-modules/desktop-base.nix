{
  lib,
  pkgs,
  roles ? {},
  ...
}: {
  config = lib.mkIf (roles.desktop.enable or false) {
    home.packages = with pkgs; [
      # File managers
      nautilus
      dolphin

      # System utilities
      htop

      # Terminal emulators
      alacritty
      terminator
      konsole
    ];

    # Enable alacritty with sensible defaults
    programs.alacritty = {
      enable = lib.mkDefault true;
      settings = {
        font.size = lib.mkDefault 12;
      };
    };
  };
}
