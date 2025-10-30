_: {
  imports = [];
  home.stateVersion = "24.05";

  # Program configurations
  programs = {
    # Enable bat for better cat output
    bat.enable = true;

    # SSH configuration
    ssh = {
      enable = true;
      matchBlocks = {};
      extraConfig = "";
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
