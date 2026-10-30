# Engineering platform standard

This document defines how the repositories owned by this account are governed as one
engineering platform. It complements `SECURITY_BASELINE.md`; it does not replace
language-specific CI or a project-specific threat model.

## 1. Sources of truth

| Concern | Source of truth | Enforcement |
|---|---|---|
| Cross-language security checks | Reusable workflows in this repository | Required CI jobs in each consumer |
| Language and framework checks | The matching template repository | Blocking CI in that template |
| Branch protection | `rulesets/*.json` | Active GitHub rulesets |
| Dependency update policy | Each repository's `.github/dependabot.yml` | Dependabot PRs, reviewed and tested by CI |
| Project risk and exceptions | Project threat model and `security-exceptions.json` | `security-policy` workflow |
| Release provenance | `release-verification.yml` plus project release workflow | Verification before install/deploy |

A control is not considered implemented merely because it is documented. It must be
enforced by a blocking check or covered by an approved, unexpired exception.

## 2. Repository tiers

- **Basic:** libraries, local tools and non-sensitive automation.
- **Standard:** public-facing applications, APIs, services and distributable applications.
- **Critical:** privileged agents, root installers, automatic production updates and infrastructure control planes.

Projects select a tier in their README or threat model. The higher tier applies when
privileges or exposure are unclear. The mandatory controls and tier definitions live
in `SECURITY_BASELINE.md`.

## 3. Required baseline for every template

Every maintained template must provide:

1. Pull-request based changes to `main`, with the active `waldonso2-main-standard` ruleset.
2. Read-only workflow permissions by default; narrower write permissions only at job level.
3. Full-SHA pinning for third-party Actions and reusable workflows.
4. Secret scanning across repository history and workflow security analysis via quality-kit.
5. Dependency review on pull requests, plus ecosystem-specific vulnerability auditing.
6. Lockfiles and reproducible/locked dependency installation where supported.
7. CodeQL and OpenSSF Scorecard where supported by the language and repository.
8. Tests, linting, type/static analysis and build checks appropriate to the stack.
9. Release provenance and verification for downloadable or deployable artifacts.
10. A project threat model, security tier and documented exception process.

Performance checks may report regressions but must not block delivery unless a project
explicitly adopts a performance SLO as a release criterion.

## 4. Dependency update policy

Dependabot configuration belongs in each repository because GitHub reads
`.github/dependabot.yml` locally. It is intentionally not generated from a remote
central file.

- Runtime and development dependencies: weekly proposals where an ecosystem supports it.
- GitHub Actions: monthly proposals.
- Cooldown: at least seven days for newly released versions.
- Every update must pass the repository's normal required CI checks.
- Security alerts are triaged promptly; the cooldown is not a reason to defer a known
  actively exploited vulnerability.
- Do not auto-merge dependency updates. Review compatibility, lockfile changes and
  release notes before merging.

The templates currently use ecosystem-specific update managers: pip, npm and cargo.
The CLI and web Python templates share the pip and GitHub Actions policy.

## 5. Shared workflow lifecycle

Reusable workflows in this repository are public interfaces. Consumer repositories
must pin them to immutable commit SHAs, never a movable branch or tag.

1. Make a change here and validate it in this repository.
2. For behavior changes that can break consumers or tighten enforcement, create a new
   major release line. Additive, backwards-compatible changes may use a minor release.
3. Update the consumer templates in pull requests, moving their pins to the reviewed
   release commit.
4. Confirm required status-check names remain stable. If a job name changes, update
   the matching ruleset JSON and apply/read back the ruleset before relying on it.
5. Keep a short compatibility note in the release PR and retain the previous immutable
   commit as a rollback target.

Do not silently change consumer behavior by moving a tag. The commit SHA is the
authoritative version.

## 6. Template propagation

Template repositories are starter kits, not live inheritance. Changes to a template
do not retroactively update projects created from it.

When a baseline change is approved:

1. Update this repository first if the change is cross-language.
2. Update each affected template in a separate pull request.
3. Run its full required checks and verify its branch ruleset still recognizes them.
4. Record the new baseline commit and any migration steps in the template changelog.
5. For existing application repositories, create explicit migration pull requests;
   never assume that changing a template updates existing projects.

## 7. New repository onboarding

A new repository is ready for production work only after:

- it is created from the closest matching template;
- the repository settings and branch ruleset are applied;
- required secrets and security features are enabled where the GitHub plan permits;
- its project tier and threat model are recorded;
- the first pull request passes all required checks;
- release and rollback procedures are documented for deployable software.

Use `SETUP.md`, `SECURITY_CHECKLIST.md` and `THREAT_MODEL_TEMPLATE.md` as the
onboarding checklist.

## 8. Operating cadence

| Frequency / trigger | Review |
|---|---|
| Weekly | Dependabot and security alert PRs |
| Monthly | GitHub Actions updates and stale open dependency PRs |
| Each quality-kit release | Consumer template pins and compatibility |
| New template or major architecture change | Tier, threat model, ruleset and CI coverage |
| At least annually | Security baseline and this platform standard |
| After an incident | Relevant controls, exceptions and release/deployment process |

## 9. Rollout sequence

The initial platform consists of `quality-kit` and the four maintained templates:
Python Web, Python CLI, TypeScript React and Rust.

The rollout is deliberately pull-request driven:

- **Phase A — governance:** define the shared standard and ownership model here.
- **Phase B — template conformance:** verify each template against the required baseline,
  including Dependabot cadence, immutable shared-workflow pins and required check names.
- **Phase C — drift detection:** add a read-only scheduled check that reports missing or
  outdated baseline references without changing repositories automatically.
- **Phase D — controlled propagation:** create reviewed PRs for template updates and,
  where needed, existing project migrations.

No workflow in this repository may directly push to a consumer's default branch or
auto-merge a propagated change. Pull requests remain the approval and rollback boundary.
