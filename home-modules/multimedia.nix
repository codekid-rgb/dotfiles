{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkMerge [
    # Video tools
    (lib.mkIf (config.roles.multimedia.enable && config.roles.multimedia.video) {
      home.packages = with pkgs; [
        obs-studio # Video recording/streaming
        plex-media-player # Media player
        # mpv
        # vlc
      ];
    })

    # Audio tools
    (lib.mkIf (config.roles.multimedia.enable && config.roles.multimedia.audio) {
      home.packages = with pkgs; [
        audacity # Audio editing
        alsa-utils # ALSA utilities
        # pavucontrol # PulseAudio volume control
      ];
    })

    # Graphics tools
    (lib.mkIf (config.roles.multimedia.enable && config.roles.multimedia.graphics) {
      home.packages = with pkgs; [
        # gimp # Image editor
        # inkscape # Vector graphics
        # krita # Digital painting
      ];
    })
  ];
}
