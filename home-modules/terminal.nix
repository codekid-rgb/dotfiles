{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.roles.terminal.enable {
    home.packages = with pkgs; [
      # Core shell utilities
      fish
      bash
      zsh

      # File navigation and search
      fd
      fzf
      fzy
      ripgrep
      tree
      eza # Modern ls replacement

      # System monitoring
      btop
      htop
      killall

      # File management
      dua # Disk usage analyzer
      ncdu

      # Text processing
      jq
      yq

      # Network tools
      curl
      wget
      mosh
      openssh

      # Archive tools
      unzip
      zip
      xz

      # Security/secrets
      age
      sops

      # Documentation
      tldr

      # Misc utilities
      gnused
    ];

    # Enable fish if terminal is enabled
    programs.fish.enable = lib.mkDefault true;
  };
}
