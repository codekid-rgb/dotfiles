# GitHub Actions Workflows

This directory contains automated workflows for the dotfiles repository.

## Available Workflows

### Auto-fix Lint Issues (`auto-fix.yml`)

Automatically fixes formatting and linting issues on pull requests.

**How to use:**
1. Create or open a pull request
2. Add the `auto-fix` label to the PR
3. The workflow will automatically:
   - Run `alejandra` to format Nix code
   - Run `statix fix` to apply lint fixes
   - Run `deadnix --edit` to remove unused code
   - Commit and push any changes back to the PR branch
   - Post a comment with the results
   - Remove the `auto-fix` label when complete

**What gets fixed:**
- **Formatting**: Standardizes code style using alejandra
- **Lint fixes**: Applies automatic fixes for statix warnings
- **Dead code**: Removes unused Nix bindings

**Note:** Only automatically fixable issues will be resolved. Manual review may still be needed for complex issues.

### CI Checks (`check.yml` and `ci-optimized.yml`)

These workflows run on every push and pull request to verify:
- Code formatting (check only, doesn't auto-fix)
- Statix linting (check only)
- Deadnix unused code detection (check only)
- Build validation for all system configurations

These checks must pass before merging PRs.

## Creating the auto-fix Label

To use the auto-fix workflow, you need to create the `auto-fix` label in your repository:

```bash
gh label create auto-fix --description "Trigger automatic lint fixing" --color "0e8a16"
```

Or create it manually through the GitHub UI:
1. Go to: `https://github.com/[owner]/[repo]/labels`
2. Click "New label"
3. Name: `auto-fix`
4. Description: "Trigger automatic lint fixing"
5. Color: Green (#0e8a16)

## Tips

- Run `nix fmt` and `nix develop -c statix check` locally before pushing to catch issues early
- The auto-fix workflow is safe to run multiple times
- If the workflow fails, check the logs for details on what couldn't be fixed automatically
- Manual intervention may be needed for complex issues that can't be auto-fixed
