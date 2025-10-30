{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.roles.onepassword.enable {
    # Install 1Password GUI application
    home.packages = with pkgs; [
      _1password-gui
    ];

    # Optional: Configure 1Password CLI if needed
    # _1password can be added here when CLI is needed
  };
}
