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
      
      albert #like spolight but better in every way and it does not care about desktop
      # GNOME extensions (commented out - uncomment as needed)
      gnomeExtensions.pop-shell
      gnomeExtensions.open-bar
      gnomeExtensions.dash-to-dock
      # gnomeExtensions.appindicator
      # gnomeExtensions.clipboard-history
      # gnomeExtensions.caffeine
      gnomeExtensions.vitals
      gnomeExtensions.hide-activities-button
      gnomeExtensions.unite
    ];
  };
}
