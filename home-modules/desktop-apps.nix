{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkMerge [
    # Productivity apps
    (lib.mkIf (config.roles.desktop.enable && config.roles.desktop.productivity) {
      home.packages = with pkgs; [
        libreoffice
        evince # PDF viewer
        typst # Modern markup-based typesetting
        typst-lsp # Typst language server
      ];
    })

    # Web browsers
    (lib.mkIf (config.roles.desktop.enable && config.roles.desktop.browsers) {
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
    (lib.mkIf (config.roles.desktop.enable && config.roles.desktop.communication) {
      home.packages = with pkgs; [
        discord
        # slack
        # signal-desktop
        # telegram-desktop
      ];
    })

    # VS Code for desktop users
    (lib.mkIf config.roles.desktop.enable {
      programs.vscode.enable = lib.mkDefault true;
    })
  ];
}
