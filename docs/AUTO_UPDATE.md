# Automatic Dotfiles Updates

This repository includes a NixOS module for automatically updating system configurations when the dotfiles repository changes.

## How It Works

The `auto-update.nix` module creates a systemd service that:

1. **On boot** (or on a timer if configured):
   - Checks if the dotfiles git repository has updates
   - Fetches the latest changes from the remote
   - Compares local vs remote commits

2. **If updates are found**:
   - Pulls the latest changes
   - Performs a dry-run to validate the configuration
   - Applies the new configuration using `nixos-rebuild switch`
   - Optionally reboots if the kernel was updated

3. **Safety features**:
   - Stashes local modifications before pulling
   - Dry-run validation before applying
   - Automatic rollback on failure
   - Detailed logging via systemd journal

## Configuration

### Simple Configuration (Recommended)

The easiest way to enable auto-updates is using the role-based configuration in `flake.nix`:

```nix
roles = {
  # ... your other roles ...
  autoUpdate = {
    enable = true;   # That's it! Sensible defaults are applied
    periodic = false; # Optional: set to true for daily updates
  };
};
```

This automatically:
- Uses `/etc/dotfiles` as the repository location (override with `system.autoUpdate.flakePath` if needed)
- Checks for updates on boot
- Tracks the `main` branch
- Uses `nixos-rebuild switch`
- Won't auto-reboot

### Advanced Configuration

For more control, you can override any defaults:

```nix
system.autoUpdate = {
  enable = true;                           # Enable the feature
  onBoot = true;                           # Check on boot (default: true)
  onCalendar = "daily";                    # Optional: periodic checks (default: null)
  flakePath = "/home/clord/dotfiles";     # Path to your dotfiles repo (default: /etc/dotfiles)
  branch = "develop";                      # Git branch to track (default: main)
  operation = "boot";                      # "switch", "boot", or "test" (default: switch)
  allowReboot = true;                      # Auto-reboot on kernel updates (default: false)
};
```

### Options Explained

- **`enable`**: Master switch for the auto-update feature
- **`onBoot`**: Whether to check for updates when the system boots (default: true)
- **`onCalendar`**: Systemd timer expression for periodic checks (default: null)
  - Examples: `"hourly"`, `"daily"`, `"weekly"`, `"*:0/15"` (every 15 min)
  - Set to `null` to disable periodic updates
- **`flakePath`**: Absolute path to your dotfiles git repository (default: `/etc/dotfiles`)
- **`branch`**: Git branch to track for updates (default: `"main"`)
- **`operation`**: NixOS rebuild operation (default: `"switch"`)
  - `"switch"`: Apply immediately and on next boot
  - `"boot"`: Apply only on next boot
  - `"test"`: Apply immediately but not persistent
- **`allowReboot`**: If true, system will auto-reboot when kernel is updated (default: false)
- **`gitUser`**: User to run git operations as, for SSH key access (default: `"clord"`)
  - Git commands run as this user to access their SSH keys
  - `nixos-rebuild` still runs as root with proper privileges

## Monitoring

### Check service status

```bash
# Check if the service ran successfully
systemctl status dotfiles-auto-update.service

# View recent logs
journalctl -u dotfiles-auto-update.service -n 50

# Follow logs in real-time
journalctl -u dotfiles-auto-update.service -f
```

### Check timer status (if periodic updates enabled)

```bash
# List all timers and check when next run is scheduled
systemctl list-timers dotfiles-auto-update.timer

# Check timer status
systemctl status dotfiles-auto-update.timer
```

### Manual trigger

```bash
# Manually trigger an update check
sudo systemctl start dotfiles-auto-update.service

# Watch it run
journalctl -u dotfiles-auto-update.service -f
```

## Example Configurations

### Boot-only updates (safest, recommended)

**Using roles (simplest):**
```nix
roles.autoUpdate.enable = true;
```

**Direct configuration:**
```nix
system.autoUpdate.enable = true;
# That's it! Uses sensible defaults:
#   flakePath = "/etc/dotfiles"
#   onBoot = true
#   branch = "main"
#   operation = "switch"

# Or override if needed:
# system.autoUpdate.flakePath = "/home/clord/dotfiles";
```

### Daily updates

**Using roles:**
```nix
roles.autoUpdate = {
  enable = true;
  periodic = true;  # Enables daily updates
};
```

**Direct configuration:**
```nix
system.autoUpdate = {
  enable = true;
  onCalendar = "daily";  # Check once per day (in addition to boot)
};
```

### Daily updates with auto-reboot

**Direct configuration only (no role option for allowReboot):**
```nix
system.autoUpdate = {
  enable = true;
  onBoot = true;
  onCalendar = "daily";  # Check once per day
  flakePath = "/home/clord/dotfiles";
  operation = "switch";
  allowReboot = true;  # Reboot if kernel updated
};
```

### Frequent updates (every 30 minutes)

Perfect for workstations where you want changes applied quickly:

```nix
system.autoUpdate = {
  enable = true;
  onCalendar = "*:0/30";  # Every 30 minutes
};
```

Or every hour:

```nix
system.autoUpdate = {
  enable = true;
  onCalendar = "hourly";
};
```

Note: Service runs at low priority (Nice=19, idle I/O) so it won't impact performance.

### Test-only mode (non-persistent)

```nix
system.autoUpdate = {
  enable = true;
  onCalendar = "daily";
  operation = "test";  # Changes won't persist across reboots
};
```

## How It Works (Systemd)

Once enabled, systemd handles everything automatically:

1. **On boot** (if `onBoot = true`, which is the default):
   - The `dotfiles-auto-update.service` runs after network is online
   - Checks for updates and applies if found
   - Logs everything to systemd journal

2. **On schedule** (if `onCalendar` is set):
   - A systemd timer triggers the service at the specified interval
   - Same update check runs automatically

3. **Low priority execution**:
   - Service runs with Nice=19 (lowest CPU priority)
   - Uses idle I/O and CPU scheduling
   - Won't impact system performance or user experience

4. **No manual intervention needed**:
   - You just push to your git repo
   - Next boot (or timer trigger), changes apply automatically
   - Check logs anytime with `journalctl -u dotfiles-auto-update.service`

## Prerequisites

For this to work, ensure:

1. **Git repository is cloned**: The dotfiles must be cloned to `/etc/dotfiles` (or your custom `flakePath`)
   - Clone as root: `sudo git clone <your-repo> /etc/dotfiles`

2. **Git credentials configured**: Git operations run as the configured user (default: `clord`)
   - For public repos, no credentials needed
   - For private repos, ensure the user has SSH keys set up:
     ```bash
     # As clord user
     ssh-keyscan github.com >> ~/.ssh/known_hosts
     # Add your SSH key to GitHub
     ```
   - The service runs git commands as this user via `sudo -u clord git ...`
   - This allows git to use the user's SSH keys for authentication

3. **Network access**: System needs internet to fetch updates

4. **Permissions**:
   - Service runs as root for `nixos-rebuild`
   - Git operations run as configured user for SSH key access
   - Repository should be readable by the git user

## Workflow Integration

### Typical workflow with auto-updates enabled on wildwood:

1. **Make changes** on your development machine:
   ```bash
   # Edit dotfiles
   vim systems/wildwood.nix

   # Test locally (optional)
   make nixos-switch

   # Commit and push
   git add -A
   git commit -m "Update wildwood configuration"
   git push origin main
   ```

2. **Wildwood automatically updates**:
   - **On next boot**: If `onBoot = true`
   - **On schedule**: If `onCalendar` is set
   - **Manually**: Run `sudo systemctl start dotfiles-auto-update.service`

3. **Check results**:
   ```bash
   # SSH into wildwood
   ssh wildwood

   # Check if update ran
   journalctl -u dotfiles-auto-update.service -n 100
   ```

## Troubleshooting

### Updates not applying

```bash
# Check service status
systemctl status dotfiles-auto-update.service

# View full logs
journalctl -u dotfiles-auto-update.service --no-pager

# Check git status in flake path
cd /home/clord/dotfiles
git status
git fetch origin main
git log --oneline origin/main..HEAD
```

### Service failed

```bash
# View error details
journalctl -u dotfiles-auto-update.service -n 100 --no-pager

# Manually run the update to see errors
cd /home/clord/dotfiles
sudo nixos-rebuild switch --flake .#wildwood
```

### Rollback failed update

```bash
# If auto-update applied a broken config, rollback:
sudo nixos-rebuild switch --rollback

# Or select a specific generation:
sudo nixos-rebuild switch --switch-generation <number>

# Then fix the issue in git and push
```

### Disable auto-updates temporarily

```bash
# Stop and disable the service
sudo systemctl stop dotfiles-auto-update.service
sudo systemctl disable dotfiles-auto-update.service

# Stop the timer (if using periodic updates)
sudo systemctl stop dotfiles-auto-update.timer
sudo systemctl disable dotfiles-auto-update.timer
```

## Security Considerations

- **Service runs as root**: Can modify system configuration
- **Automatic execution**: Changes apply without manual review
- **Network dependency**: Requires trust in git remote
- **Local modifications**: Will be stashed, potentially losing work

### Recommendations:

1. **Use CI/CD validation**: Ensure configs pass checks before merging to main
2. **Test on non-critical systems first**: Try on dunbar/chickenpi before wildwood
3. **Monitor logs regularly**: Check that updates are applying correctly
4. **Keep backups**: NixOS generations provide rollback, but backup important data
5. **Start conservative**: Begin with `onBoot = true` only, add periodic updates later

## Comparison with GitHub Actions

| Feature | Auto-Update (Pull) | GitHub Actions (Push) |
|---------|-------------------|----------------------|
| Deployment trigger | System boot / timer | Git push |
| Network requirement | System needs internet | GitHub needs SSH to systems |
| Complexity | Low (systemd service) | Medium (workflows + secrets) |
| Control | Per-system config | Centralized |
| Security | Local git pull | SSH keys in GitHub |
| Best for | Workstations, boot updates | Servers, immediate deployment |

Both approaches can coexist! For example:
- **Wildwood** (workstation): Auto-update on boot
- **Dunbar/Chickenpi** (servers): GitHub Actions remote deploy
