{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.roles.development.enable {
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
      ++ lib.optionals config.roles.development.languages.go [
        go
      ]
      ++ lib.optionals config.roles.development.languages.python [
        python311Full
      ]
      ++ lib.optionals config.roles.development.languages.rust [
        # rustc
        # cargo
      ]
      ++ lib.optionals config.roles.development.languages.java [
        jdk17
      ]
      ++ lib.optionals config.roles.development.languages.racket [
        racket
      ];
  };
}
