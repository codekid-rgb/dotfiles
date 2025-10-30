{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.roles.editors.enable {
    home = {
      packages = with pkgs; [
        # Basic editors
        vim
        nano

        # Editor support tools
        editorconfig-core-c

        # Language servers and formatters for Nix
        nixd
        nil
        alejandra
        nixfmt-rfc-style
        statix
        deadnix

        # General formatters
        nodePackages.prettier
        shfmt

        # Linters
        shellcheck
        yamllint
      ];

      sessionVariables = {
        EDITOR = lib.mkDefault "nvim";
        VISUAL = lib.mkDefault "nvim";
        PAGER = lib.mkDefault "less";
      };

      # Global editorconfig
      file.".editorconfig".text = ''
        # EditorConfig is awesome: https://EditorConfig.org
        root = true

        [*]
        charset = utf-8
        end_of_line = lf
        insert_final_newline = true
        trim_trailing_whitespace = true
        indent_style = space
        indent_size = 2

        [*.{py,rs}]
        indent_size = 4

        [*.go]
        indent_style = tab

        [*.md]
        trim_trailing_whitespace = false

        [Makefile]
        indent_style = tab
      '';
    };

    # Enable neovim by default when editors are enabled
    programs.neovim.enable = lib.mkDefault true;
  };
}
