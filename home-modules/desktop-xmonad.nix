{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf (config.roles.desktop.enable && config.roles.desktop.windowManager == "xmonad") {
    home.packages = with pkgs; [
      # XMonad utilities
      dmenu # Application launcher
      nitrogen # Wallpaper setter
      feh # Image viewer / wallpaper
      trayer # System tray
      xfce.xfce4-power-manager # Power management
      xscreensaver # Screen locker
      networkmanagerapplet # Network management
      yad # Display dialogs from shell scripts
    ];

    xsession = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hp: [
          hp.dbus
          hp.monad-logger
          hp.xmonad-contrib
        ];
        # User should override this with their own config:
        # config = ./path-to-xmonad.hs;
      };
    };
  };
}
