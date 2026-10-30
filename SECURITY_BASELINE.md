# Security baseline

This document defines the minimum engineering security standard for repositories using quality-kit.
It complements, and does not replace, a project-specific threat model.

## Enforcement model

A control is considered implemented only when it is:
1. enforced by a blocking CI or release check; or
2. recorded as an approved exception in `SECURITY_EXCEPTIONS.md`, with an owner, rationale,
   compensating control, and expiry date.

A checklist entry or a statement in a README is not evidence of enforcement.

## Security tiers

| Tier | Typical use | Minimum controls |
|---|---|---|
| Basic | Local tools, libraries, non-sensitive automation | secret scanning, pinned Actions, dependency review/audit, tests, protected main branch |
| Standard | Public web apps, APIs, services, distributable applications | Basic + threat model, secure release provenance, verified downloads, runtime security review |
| Critical | Root installers, privileged agents, automatic production updates, infrastructure control planes | Standard + signature/attestation verification before execution, least privilege, anti-downgrade, locking, health checks, backup and rollback |

Choose the tier in the project README or threat model. When in doubt, choose the higher tier until a review justifies otherwise.

## Mandatory controls

### Source and repository
- Never commit credentials, tokens, private keys, production data, or real customer secrets.
- Enable secret scanning and push protection where GitHub plan and repository visibility permit.
- Protect the default branch with pull requests, required blocking checks, and no force pushes/deletion.
- Keep GitHub Actions repository permissions read-only by default. Grant write permissions per job only.
- Pin third-party Actions to full commit SHAs and keep a human-readable version comment.
- Set `persist-credentials: false` on checkout unless a later step demonstrably needs the token.

### Dependencies and build
- Commit lockfiles and use reproducible/locked installs where supported.
- Audit runtime dependencies and review new dependencies for known vulnerabilities and license/source policy.
- Build with least privilege; never expose release credentials to untrusted pull-request code.
- Treat build outputs, caches, artifacts, container tags, and checksums as untrusted until verified.

### Release and software supply chain
- Publish provenance/attestations for distributable release artifacts.
- Verify artifact attestations against the expected repository and trusted workflow identity before extraction, installation, or execution.
- Do not trust a checksum file merely because it was downloaded beside the artifact. Authenticate the checksum or verify the artifact's provenance independently.
- Prefer immutable digests over mutable tags such as `:latest`.
- Do not install from mutable branches or unpinned URLs.

### Deployment and runtime
- Run as a dedicated unprivileged account wherever possible; elevate only the narrow operation that requires it.
- Validate external input before using it in shell commands, paths, URLs, or configuration.
- Avoid shell evaluation and command construction from untrusted values.
- Make updates atomic and serialized; prevent concurrent update runs.
- Enforce anti-downgrade policy unless rollback is explicitly authorized.
- Verify health after deployment and retain a tested rollback/backup path for stateful or critical services.
- Use service-manager/container hardening and restrict filesystem, network, and Linux capabilities to what is required.

### Application security
- Define trust boundaries, sensitive assets, entry points, and abuse cases in a threat model.
- Validate authorization on the server side; do not rely on UI visibility.
- Protect secrets and personal data in logs, telemetry, backups, and error messages.
- Use secure defaults for authentication, session handling, transport security, and browser security headers where applicable.
- Treat AI-generated code as untrusted: review security-sensitive logic, run tests and static analysis, and never accept generated dependency or shell commands without inspection.

## Evidence and exceptions

Each project records:
- chosen tier and rationale;
- threat model appropriate to its exposure and privileges;
- required CI status checks;
- release verification method;
- deployment/update/rollback design when applicable.

Exceptions must be documented in `SECURITY_EXCEPTIONS.md` with: control, reason, risk, compensating measure, owner, approval, and expiry date. Expired exceptions fail review and must be resolved or renewed explicitly.

## Review cadence

Review this baseline at project start, before first public release, after material architecture/deployment changes, and at least annually. Revisit it after a security incident or significant vulnerability.
