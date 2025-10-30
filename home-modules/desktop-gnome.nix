{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf (config.roles.desktop.enable && config.roles.desktop.windowManager == "gnome") {
    home.packages = with pkgs; [
      # GNOME utilities
      gnome-tweaks
      dconf-editor
      gnome-system-monitor
      gnome-disk-utility

      # GNOME extensions (commented out - uncomment as needed)
      # gnomeExtensions.dash-to-dock
      # gnomeExtensions.appindicator
      # gnomeExtensions.clipboard-history
      # gnomeExtensions.caffeine
      # gnomeExtensions.vitals
    ];
  };
}
