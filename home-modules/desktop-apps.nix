{
  lib,
  pkgs,
  roles ? {},
  ...
}: {
  config = lib.mkMerge [
    # Productivity apps
    (lib.mkIf ((roles.desktop.enable or false) && (roles.desktop.productivity or false)) {
      home.packages = with pkgs; [
        libreoffice
        evince # PDF viewer
        typst # Modern markup-based typesetting
        typst-lsp # Typst language server
      ];
    })

    # Web browsers
    (lib.mkIf ((roles.desktop.enable or false) && (roles.desktop.browsers or false)) {
      home.packages = with pkgs; [
        # firefox # Temporarily disabled due to hash collision
        floorp # Firefox fork
        # Uncomment as needed:
        # chromium
        # google-chrome
        # brave
      ];

      # Firefox configuration (when enabled)
      # programs.firefox.enable = true;
    })

    # Communication apps
    (lib.mkIf ((roles.desktop.enable or false) && (roles.desktop.communication or false)) {
      home.packages = with pkgs; [
        discord
        # slack
        # signal-desktop
        # telegram-desktop
      ];
    })

    # VS Code for desktop users
    (lib.mkIf (roles.desktop.enable or false) {
      programs.vscode.enable = lib.mkDefault true;
    })
  ];
}
