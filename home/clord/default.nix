_: {
  imports = [
    ./common.nix
    ./packages/linux.nix
    ./modules # Use modular configuration
    ./programs
    ../../home-modules # Import shared modules
  ];

  # Enable 1Password for clord
  roles.onepassword.enable = true;

  programs.fish.enable = true;
}
