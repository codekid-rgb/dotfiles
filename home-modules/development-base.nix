{
  lib,
  pkgs,
  roles ? {},
  ...
}: {
  config = lib.mkIf (roles.development.enable or false) {
    home.packages = with pkgs;
      [
        # Version control
        git
        gh # GitHub CLI

        # Build tools
        gcc
        gnumake

        # General dev utilities
        jq
        yq

        # Database tools
        # sqlite
      ]
      # Language-specific packages
      ++ lib.optionals (roles.development.languages.go or false) [
        go
      ]
      ++ lib.optionals (roles.development.languages.python or false) [
        python311Full
      ]
      ++ lib.optionals (roles.development.languages.rust or false) [
        # rustc
        # cargo
      ]
      ++ lib.optionals (roles.development.languages.java or false) [
        jdk17
      ]
      ++ lib.optionals (roles.development.languages.racket or false) [
        racket
      ];
  };
}
