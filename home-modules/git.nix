{
  lib,
  pkgs,
  roles ? {},
  ...
}: let
  rg = "${pkgs.ripgrep}/bin/rg";
in {
  config = lib.mkIf (roles.git.enable or false) {
    programs.git = {
      enable = true;
      lfs.enable = lib.mkDefault true;

      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
        ".idea"
      ];

      # Common aliases that work for everyone
      aliases = {
        # Status and log
        st = "status";
        s = "status -s";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
        ls = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'';
        ll = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
        last = "log -1 HEAD";
        tree = "log --graph --decorate --pretty=oneline --abbrev-commit --all";

        # Branching
        br = "branch";
        co = "checkout";

        # Committing
        c = "commit -am";
        com = "commit -m";
        ca = "commit -am";
        amend = "commit --amend";

        # Diffing
        d = "diff -w --minimal --word-diff=color --color-words --abbrev";
        dc = "diff --cached";
        dt = "difftool";
        staged = "diff --cached";
        unstaged = "diff";

        # Staging
        a = "add";
        ai = "add --interactive";
        unstage = "reset HEAD --";

        # Lines of code counter
        loc = ''!f(){ git ls-files | ${rg} "\.''${1}" | xargs wc -l; };f'';
      };

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = lib.mkDefault true;

        # Better merge conflict display
        merge = {
          conflictStyle = lib.mkDefault "zdiff3";
          stat = "true";
        };

        # URL shortcuts
        url = {
          "https://github.com/".insteadOf = "gh:";
          "ssh://git@github.com".pushInsteadOf = "gh:";
          "https://gitlab.com/".insteadOf = "gl:";
          "ssh://git@gitlab.com".pushInsteadOf = "gl:";
        };

        # Better diffs
        diff = {
          algorithm = "histogram";
          compactionHeuristic = "true";
          colorMoved = "zebra";
        };

        # Better logging
        log = {
          decorate = "short";
          date = "local";
        };

        # Push settings
        push = {
          default = "current";
          autoSetupRemote = "true";
          followTags = "true";
        };

        # Fetch settings
        fetch = {
          prune = "true";
          fsckobjects = lib.mkDefault true;
        };

        # Transfer settings
        transfer.fsckobjects = lib.mkDefault true;

        # Commit settings
        commit.verbose = true;

        # Branch settings
        branch = {
          autoSetupMerge = "true";
          sort = "-committerdate";
        };

        # Reuse recorded resolutions
        rerere = {
          enabled = "true";
          autoupdate = "true";
        };

        # Formatting
        format.numbered = "auto";
        apply.whitespace = "fix,trailing-space,space-before-tab,cr-at-eol";
      };
    };

    home.packages = with pkgs; [
      git-lfs
    ];
  };
}
