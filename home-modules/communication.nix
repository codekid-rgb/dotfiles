{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.roles.communication.enable {
    home.packages = with pkgs; [
      # Commented out - enable in desktop-apps.nix or per-user
      # discord
      # slack
      # signal-desktop
      # telegram-desktop
    ];
  };
}
