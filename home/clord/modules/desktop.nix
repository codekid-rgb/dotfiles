{
  lib,
  pkgs,
  roles,
  ...
}: {
  config = lib.mkMerge [
    # Base desktop utilities
    (lib.mkIf roles.desktop.enable {
      home.packages = with pkgs; [
        # Core desktop tools
        gnome.gnome-tweaks # GNOME customization
        dconf-editor # GNOME settings editor

        # File management
        # (nautilus is included with GNOME by default)

        # System utilities
        gnome.gnome-system-monitor # System monitor
        gnome.gnome-disk-utility # Disk management

        # Additional desktop utilities (commented out - uncomment as needed):
        # gnomeExtensions.dash-to-dock      # Better dock
        # gnomeExtensions.appindicator      # System tray icons
        # gnomeExtensions.clipboard-history # Clipboard manager
        # gnomeExtensions.caffeine          # Prevent sleep
        # gnomeExtensions.vitals            # System monitor in panel
        # gnomeExtensions.gsconnect         # KDE Connect for GNOME
        # flameshot        # Screenshot tool
        # gparted          # Partition manager
        # timeshift        # System backup
        # syncthing        # File synchronization
        # remmina          # Remote desktop client
        # anydesk          # Remote desktop
        # barrier          # Share keyboard/mouse across computers
      ];
    })

    # Web browsers
    (lib.mkIf (roles.desktop.enable && roles.desktop.browsers) {
      home.packages = with pkgs; [
        firefox # Default browser

        # Additional browsers (commented out - uncomment as needed):
        # google-chrome    # Google Chrome
        # chromium         # Open source Chrome
        # brave            # Privacy-focused browser
        # vivaldi          # Feature-rich browser
        # microsoft-edge   # Edge browser
        # tor-browser-bundle-bin # Tor browser
      ];

      # Firefox configuration
      programs.firefox = {
        enable = true;
        # Add profile customization here if needed
      };
    })

    # Communication tools
    (lib.mkIf (roles.desktop.enable && roles.desktop.communication) {
      home.packages = with pkgs; [
        slack # Work communication
        discord # Gaming/community chat

        # Additional communication tools (commented out - uncomment as needed):
        # signal-desktop   # Secure messaging
        # telegram-desktop # Telegram messaging
        # element-desktop  # Matrix client
        # zoom-us          # Video conferencing
        # teams-for-linux  # Microsoft Teams
        # skypeforlinux    # Skype
        # thunderbird      # Email client
        # evolution        # GNOME email client
        # hexchat          # IRC client
        # weechat          # Terminal IRC client
      ];
    })

    # Productivity tools
    (lib.mkIf (roles.desktop.enable && roles.desktop.productivity) {
      home.packages = with pkgs; [
        # Office suite
        libreoffice-fresh # Office suite

        # PDF tools
        evince # PDF viewer (GNOME default)

        # Note-taking
        # obsidian         # Knowledge base (unfree)

        # Additional productivity tools (commented out - uncomment as needed):
        # onlyoffice-bin   # Alternative office suite
        # calibre          # E-book management
        # zotero           # Reference manager
        # okular           # Advanced PDF viewer
        # xournal          # PDF annotation
        # rnote            # Note-taking
        # logseq           # Knowledge base
        # notion-app-enhanced # Notion desktop
        # drawio           # Diagramming tool
        # xmind            # Mind mapping
        # freeplane        # Mind mapping
        # typora           # Markdown editor
        # marktext         # Markdown editor
        # keepassxc        # Password manager
        # gnucash          # Personal finance
        # homebank         # Personal finance
      ];
    })
  ];
}
