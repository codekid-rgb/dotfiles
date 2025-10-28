# Waba-specific SSH configuration for GitHub (personal + Grafana)
_: {
  programs.ssh.extraConfig = ''
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

    # Personal GitHub
    Host personal.github.com
      User git
      HostName github.com
      IdentityFile ~/.ssh/personal_git.pub
      IdentitiesOnly yes

    # Grafana GitHub
    Host grafana.github.com
      User git
      HostName github.com
      IdentityFile ~/.ssh/grafana_git.pub
      IdentitiesOnly yes
  '';
}
