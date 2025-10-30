{pkgs, ...}: {
  imports = [./common.nix ./programs ./modules];

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
    vscode.enable = true;
    alacritty = {
      enable = true;
      settings = {font.size = 14;};
    };
    firefox.enable = true;
    git.enable = true;
    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
  };
  home.packages = with pkgs; [
    alsa-utils
    audacity
    discord
    # dmenu - moved to xmonad module
    dolphin
    typst
    typst-lsp
    go
    hledger
    godot_4
    # element-desktop # Removed: depends on insecure olm library (CVE-2024-45191/2/3)
    exfat
    eza
    fd
    # feh - moved to xmonad module
    floorp
    gcc
    nautilus # Changed from gnome.nautilus
    gnumake
    htop
    jdk17
    killall
    konsole
    libreoffice
    # matrix-commander # Removed: depends on insecure olm library
    networkmanagerapplet
    # nitrogen - moved to xmonad module
    obs-studio
    plex-media-player
    prismlauncher
    python311Full
    racket
    steam
    terminator
    # trayer - moved to xmonad module
    xfce.xfce4-power-manager
    xscreensaver
    yad
    zlib
  ];

  systemd.user.startServices = "sd-switch";
}
