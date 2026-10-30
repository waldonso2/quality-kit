#!/usr/bin/env bash
set -Eeuo pipefail

# Apply the versioned main-branch rulesets to the five waldonso2 repositories.
# Requires: gh, jq, and a GitHub token/user with Administration: write on each repo.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULESET_NAME="waldonso2-main-standard"
REPOS=(
  "quality-kit"
  "template-python-web"
  "template-python-cli"
  "template-ts-react"
  "template-rust"
)

command -v gh >/dev/null || { echo "Missing dependency: gh" >&2; exit 1; }
command -v jq >/dev/null || { echo "Missing dependency: jq" >&2; exit 1; }
gh auth status >/dev/null

for repo in "${REPOS[@]}"; do
  file="${ROOT_DIR}/rulesets/${repo}.json"
  [[ -f "$file" ]] || { echo "Missing ruleset: $file" >&2; exit 1; }
  jq -e '.name == "waldonso2-main-standard" and .target == "branch" and .enforcement == "active"' "$file" >/dev/null

  echo "==> Applying ${repo}"
  existing_id="$(gh api "repos/waldonso2/${repo}/rulesets" --jq '.[] | select(.name == "waldonso2-main-standard") | .id' | head -n 1 || true)"

  if [[ -n "${existing_id}" ]]; then
    gh api --method PUT "repos/waldonso2/${repo}/rulesets/${existing_id}" --input "$file" >/dev/null
    echo "Updated ruleset id ${existing_id}"
  else
    created="$(gh api --method POST "repos/waldonso2/${repo}/rulesets" --input "$file")"
    echo "Created ruleset id $(jq -r '.id' <<<"$created")"
  fi

  applied="$(gh api "repos/waldonso2/${repo}/rulesets" --jq '.[] | select(.name == "waldonso2-main-standard") | [.id,.enforcement] | @tsv')"
  [[ -n "$applied" ]] || { echo "Ruleset verification failed for ${repo}" >&2; exit 1; }
  echo "Verified: ${applied}"
done

echo "All five repository rulesets are active."
