{
  lib,
  pkgs,
  roles ? {},
  ...
}: {
  config = lib.mkMerge [
    # Video tools
    (lib.mkIf ((roles.multimedia.enable or false) && (roles.multimedia.video or false)) {
      home.packages = with pkgs; [
        obs-studio # Video recording/streaming
        plex-media-player # Media player
        # mpv
        # vlc
      ];
    })

    # Audio tools
    (lib.mkIf ((roles.multimedia.enable or false) && (roles.multimedia.audio or false)) {
      home.packages = with pkgs; [
        audacity # Audio editing
        alsa-utils # ALSA utilities
        # pavucontrol # PulseAudio volume control
      ];
    })

    # Graphics tools
    (lib.mkIf ((roles.multimedia.enable or false) && (roles.multimedia.graphics or false)) {
      home.packages = with pkgs; [
        # gimp # Image editor
        # inkscape # Vector graphics
        # krita # Digital painting
      ];
    })
  ];
}
