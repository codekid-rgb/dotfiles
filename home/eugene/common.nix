_: {
  imports = [];
  home.stateVersion = "24.05";

  # Enable bat for better cat output
  programs.bat.enable = true;

  # SSH configuration
  programs.ssh = {
    enable = true;
    matchBlocks = {};
    extraConfig = "";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
