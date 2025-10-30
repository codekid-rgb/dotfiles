{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  # Support both the role-based config and the direct config
  roleEnabled = config.roles.autoUpdate.enable or false;
  cfg = config.system.autoUpdate;

  # Smart defaults for flake path
  defaultFlakePath =
    if pathExists "/home/clord/dotfiles/.git" then "/home/clord/dotfiles"
    else if pathExists "/etc/nixos/.git" then "/etc/nixos"
    else "/etc/nixos";
in {
  options.system.autoUpdate = {
    enable = mkEnableOption "automatic dotfiles updates";

    onBoot = mkOption {
      type = types.bool;
      default = true;
      description = "Check for updates on boot";
    };

    onCalendar = mkOption {
      type = types.nullOr types.str;
      default = if (config.roles.autoUpdate.periodic or false) then "daily" else null;
      example = "hourly";
      description = ''
        Systemd calendar expression for periodic updates.
        Set to null to disable periodic updates.
        Examples: "hourly", "daily", "weekly", "*:0/15" (every 15 minutes)
      '';
    };

    flakePath = mkOption {
      type = types.path;
      default = defaultFlakePath;
      description = "Path to the dotfiles flake repository";
    };

    branch = mkOption {
      type = types.str;
      default = "main";
      description = "Git branch to track for updates";
    };

    operation = mkOption {
      type = types.enum ["switch" "boot" "test"];
      default = "switch";
      description = ''
        NixOS rebuild operation to perform:
        - switch: Apply immediately and on next boot
        - boot: Apply only on next boot
        - test: Apply immediately but not on next boot
      '';
    };

    allowReboot = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Allow automatic reboot if kernel was updated.
        Only applies when operation is "switch" or "boot".
      '';
    };
  };

  # Enable the module if either the role is enabled or the direct config is enabled
  config = mkIf (cfg.enable || roleEnabled) (mkMerge [
    # Auto-enable if using role-based config
    (mkIf roleEnabled {
      system.autoUpdate.enable = true;
    })
    {
      systemd.services.dotfiles-auto-update = {
        description = "Automatic dotfiles update service";
        wants = ["network-online.target"];
        after = ["network-online.target"];

        # Only run on boot if configured
        wantedBy = mkIf cfg.onBoot ["multi-user.target"];

        path = with pkgs; [
          git
          nixos-rebuild
          nix
          gawk
        ];

        serviceConfig = {
          Type = "oneshot";
          User = "root";
          # Prevent service from failing the boot process
          SuccessExitStatus = "0 1";
        };

        script = ''
          set -euo pipefail

          FLAKE_PATH="${cfg.flakePath}"
          BRANCH="${cfg.branch}"
          HOSTNAME="$(hostname -s)"
          LOG_PREFIX="[dotfiles-auto-update]"

          echo "$LOG_PREFIX Starting dotfiles auto-update check..."

          # Ensure we're in the flake directory
          if [[ ! -d "$FLAKE_PATH" ]]; then
            echo "$LOG_PREFIX Error: Flake path $FLAKE_PATH does not exist"
            exit 1
          fi

          cd "$FLAKE_PATH"

          # Ensure it's a git repository
          if [[ ! -d .git ]]; then
            echo "$LOG_PREFIX Error: $FLAKE_PATH is not a git repository"
            exit 1
          fi

          # Store current commit before pulling
          CURRENT_COMMIT=$(git rev-parse HEAD)
          echo "$LOG_PREFIX Current commit: $CURRENT_COMMIT"

          # Fetch latest changes
          echo "$LOG_PREFIX Fetching latest changes from origin..."
          if ! git fetch origin "$BRANCH"; then
            echo "$LOG_PREFIX Warning: Failed to fetch from remote. Using local state."
            exit 1
          fi

          # Check if there are updates
          REMOTE_COMMIT=$(git rev-parse "origin/$BRANCH")
          echo "$LOG_PREFIX Remote commit: $REMOTE_COMMIT"

          if [[ "$CURRENT_COMMIT" == "$REMOTE_COMMIT" ]]; then
            echo "$LOG_PREFIX No updates available. System is up to date."
            exit 0
          fi

          echo "$LOG_PREFIX Updates available. Pulling changes..."

          # Check for local modifications
          if [[ -n $(git status --porcelain) ]]; then
            echo "$LOG_PREFIX Warning: Local modifications detected. Stashing changes..."
            git stash push -m "auto-update-$(date +%Y%m%d-%H%M%S)"
          fi

          # Pull the latest changes
          if ! git pull origin "$BRANCH"; then
            echo "$LOG_PREFIX Error: Failed to pull updates"
            exit 1
          fi

          NEW_COMMIT=$(git rev-parse HEAD)
          echo "$LOG_PREFIX Updated to commit: $NEW_COMMIT"

          # Show what changed
          echo "$LOG_PREFIX Changes:"
          git log --oneline "$CURRENT_COMMIT..$NEW_COMMIT" || true

          # Perform dry-run first as safety check
          echo "$LOG_PREFIX Performing dry-run..."
          if ! nixos-rebuild dry-activate --flake ".#$HOSTNAME"; then
            echo "$LOG_PREFIX Error: Dry-run failed. Not applying changes."
            # Rollback to previous commit
            git reset --hard "$CURRENT_COMMIT"
            exit 1
          fi

          # Apply the configuration
          echo "$LOG_PREFIX Applying new configuration..."
          if nixos-rebuild ${cfg.operation} --flake ".#$HOSTNAME"; then
            echo "$LOG_PREFIX Successfully applied configuration!"

            ${optionalString cfg.allowReboot ''
              # Check if kernel was updated and reboot if allowed
              if [[ "${cfg.operation}" != "test" ]]; then
                CURRENT_KERNEL=$(uname -r)
                NEW_KERNEL=$(readlink -f /run/current-system/kernel/bzImage | awk -F/ '{print $(NF-1)}' || echo "$CURRENT_KERNEL")

                if [[ "$CURRENT_KERNEL" != "$NEW_KERNEL" ]]; then
                  echo "$LOG_PREFIX Kernel was updated. Rebooting in 60 seconds..."
                  shutdown -r +1 "System updated with new kernel. Rebooting..."
                fi
              fi
            ''}
          else
            echo "$LOG_PREFIX Error: Failed to apply configuration"
            # Rollback to previous commit
            git reset --hard "$CURRENT_COMMIT"
            nixos-rebuild ${cfg.operation} --flake ".#$HOSTNAME" || true
            exit 1
          fi

          echo "$LOG_PREFIX Update completed successfully!"
        '';
      };

      # Optional timer for periodic updates
      systemd.timers.dotfiles-auto-update = mkIf (cfg.onCalendar != null) {
        description = "Periodic dotfiles update timer";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = cfg.onCalendar;
          Persistent = true;
          RandomizedDelaySec = "5min";
        };
      };

      # Ensure the timer triggers the service
      systemd.services.dotfiles-auto-update.wantedBy = mkIf (cfg.onCalendar != null) [];
    }
  ]);
}
