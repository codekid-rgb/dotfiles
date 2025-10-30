{
  lib,
  pkgs,
  inputs,
  roles,
  ...
}: {
  config = lib.mkIf (roles.desktop.enable && roles.terminal.enable) {
    home.packages = [
      inputs.ghostty.packages.${pkgs.system}.default
    ];

    # Ghostty configuration
    # Config file location: ~/.config/ghostty/config
    xdg.configFile."ghostty/config".text = ''
      # Font configuration
      font-family = "JetBrains Mono"
      font-size = 12

      # Theme
      theme = dark:catppuccin-mocha,light:catppuccin-latte

      # Window settings
      window-padding-x = 8
      window-padding-y = 8
      window-theme = auto

      # Performance
      shell-integration = fish

      # Keybindings
      # Use default keybindings, can customize here if needed

      # Clipboard
      clipboard-read = allow
      clipboard-write = allow

      # Additional settings (commented - uncomment as needed):
      # background-opacity = 0.95
      # cursor-style = block
      # cursor-style-blink = true
      # window-decoration = true
      # confirm-close-surface = false
    '';
  };
}
