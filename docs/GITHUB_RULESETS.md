# GitHub repository rulesets

This directory contains the versioned GitHub REST API payloads for the
`waldonso2-main-standard` branch ruleset. They target only `main` and are
kept per repository because required CI check names differ by template.

## Policy

- Changes to `main` must arrive through pull requests.
- Conversations must be resolved.
- Required checks must pass against the latest target branch.
- Force pushes and branch deletion are blocked.
- Linear history is required (use squash or rebase merges).
- Approval count is intentionally zero: this is a personal-account setup and
  a mandatory second-person review could otherwise make solo maintenance
  impossible. Add one approval if the repositories gain another maintainer.
- No bypass actors are configured in the ruleset.

The required checks are deliberately limited to checks observed on the
repositories' current default-branch/PR CI. Dependency Review is not required
because GitHub reports it as skipped when a PR has no dependency changes.
Check names must be kept in sync if workflows are renamed.

## Deploy

Requirements: GitHub CLI (`gh`), `jq`, repository admin access, and a token
with **Administration: write** permission for all five repositories.

```bash
gh auth login
./scripts/apply-rulesets.sh
```

The script is idempotent: it creates the named ruleset when absent and updates
it when already present. It then reads back each ruleset to verify that it is
active. It does not change repository Actions settings, merge settings, or
workflow files.

## Manual import

Each JSON file can also be imported from a repository's
**Settings → Rules → Rulesets → New ruleset → Import a ruleset** page.
Review the required status checks before activating the imported ruleset.

## Repositories

- `quality-kit`
- `template-python-web`
- `template-python-cli`
- `template-ts-react`
- `template-rust`
