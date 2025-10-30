{
  lib,
  pkgs,
  roles,
  ...
}: {
  config = lib.mkIf (roles.desktop.enable && roles.desktop.windowManager == "xmonad") {
    home.packages = with pkgs; [
      # XMonad utilities
      dmenu # Application launcher
      nitrogen # Wallpaper setter
      feh # Image viewer / wallpaper
      trayer # System tray
    ];

    xsession = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hp: [hp.dbus hp.monad-logger hp.xmonad-contrib];
        config = ../xmonad.hs;
      };
    };
  };
}
