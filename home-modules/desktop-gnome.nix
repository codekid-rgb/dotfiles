{
  lib,
  pkgs,
  config,
  ...
}: {
  options.roles.desktop.enable = lib.mkEnableOption "Desktop role";

  config = lib.mkIf config.roles.desktop.enable {
    home.packages = lib.mkMerge [
      (lib.mkIf (config.roles.desktop.windowManager == "gnome") (with pkgs; [
        gnome-tweaks
        dconf-editor
        gnome-system-monitor
        gnome-disk-utility
        albert
        gnomeExtensions.pop-shell
        gnomeExtensions.open-bar
        gnomeExtensions.dash-to-dock
        gnomeExtensions.vitals
        gnomeExtensions.hide-activities-button
        gnomeExtensions.unite
      ]))
    ];
  };
}

