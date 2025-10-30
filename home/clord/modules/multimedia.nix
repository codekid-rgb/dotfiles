{
  lib,
  pkgs,
  roles,
  ...
}: {
  config = lib.mkMerge [
    # Base multimedia tools
    (lib.mkIf roles.multimedia.enable {
      home.packages = with pkgs; [
        # Common media utilities
        mediainfo # Media file information
        exiftool # Metadata viewer/editor

        # Additional base tools (commented out - uncomment as needed):
        # handbrake        # Video transcoder
        # mkvtoolnix       # Matroska tools
        # subtitleedit     # Subtitle editor
        # makemkv          # DVD/Blu-ray ripper
      ];
    })

    # Video tools
    (lib.mkIf (roles.multimedia.enable && roles.multimedia.video) {
      home.packages = with pkgs; [
        vlc # Media player
        mpv # Lightweight media player
        obs-studio # Screen recording/streaming

        # Additional video tools (commented out - uncomment as needed):
        # kdenlive         # Video editor
        # shotcut          # Video editor
        # openshot-qt      # Video editor
        # davinci-resolve  # Professional video editor
        # blender          # 3D modeling & video editing
        # peek             # Simple screen recorder
        # simplescreenrecorder # Screen recorder
        # ffmpeg-full      # Complete FFmpeg with all features
      ];
    })

    # Audio tools
    (lib.mkIf (roles.multimedia.enable && roles.multimedia.audio) {
      home.packages = with pkgs; [
        audacity # Audio editor

        # Additional audio tools (commented out - uncomment as needed):
        # spotify          # Music streaming
        # spotifywm        # Spotify with window manager fixes
        # ardour           # Digital audio workstation
        # lmms             # Music production
        # reaper           # DAW
        # tenacity         # Audacity fork
        # rhythmbox        # Music player
        # clementine       # Music player
        # strawberry       # Music player (Clementine fork)
        # pavucontrol      # PulseAudio volume control
        # easyeffects      # Audio effects for PipeWire
        # helvum           # PipeWire patchbay
      ];
    })

    # Graphics and image editing
    (lib.mkIf (roles.multimedia.enable && roles.multimedia.graphics) {
      home.packages = with pkgs; [
        gimp # Image editor
        inkscape # Vector graphics

        # Additional graphics tools (commented out - uncomment as needed):
        # krita            # Digital painting
        # blender          # 3D modeling & animation
        # darktable        # Photography workflow
        # rawtherapee      # RAW photo processor
        # digikam          # Photo management
        # gthumb           # Image viewer
        # feh              # Lightweight image viewer
        # imagemagick      # Image manipulation CLI
        # gwenview         # Image viewer
        # pinta            # Simple image editor
        # hugin            # Panorama stitcher
        # scribus          # Desktop publishing
      ];
    })
  ];
}
