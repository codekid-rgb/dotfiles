{
  lib,
  pkgs,
  roles ? {},
  ...
}: {
  config = lib.mkIf (roles.communication.enable or false) {
    home.packages = with pkgs; [
      # Commented out - enable in desktop-apps.nix or per-user
      # discord
      # slack
      # signal-desktop
      # telegram-desktop
    ];
  };
}
