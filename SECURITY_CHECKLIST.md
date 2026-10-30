# Project security checklist

Use this checklist when creating a repository from a quality-kit template and before each production release.

## Project setup
- [ ] Select Basic, Standard, or Critical tier and record it in the README.
- [ ] Identify data, secrets, trust boundaries, entry points, and abuse cases.
- [ ] Add a project threat model (required for Standard and Critical).
- [ ] Enable Dependabot alerts/security updates, secret scanning/push protection, and CodeQL.
- [ ] Protect the default branch with required pull requests and blocking checks.
- [ ] Set Actions default permissions to read-only; disable Actions PR creation/approval unless justified.
- [ ] Add `SECURITY.md` with private vulnerability-reporting instructions.

## Every pull request
- [ ] Secret scan, workflow lint/security audit, dependency review, code analysis, tests, and language-specific checks pass.
- [ ] New dependencies have a clear purpose, acceptable license/source, and no unresolved known critical/high vulnerability.
- [ ] No credentials, production data, or unsafe debug output added.
- [ ] Security-sensitive changes include tests for failure/denial paths.
- [ ] Any exception is recorded with owner and expiry.

## Before release
- [ ] Build is produced by a trusted workflow from the protected default branch or a protected release tag.
- [ ] Release artifacts have provenance/attestations.
- [ ] Verification checks the expected repository and signer workflow, not merely a checksum beside the artifact.
- [ ] Release contains immutable version identifiers and checksums; mutable aliases are not the trust anchor.
- [ ] No release credential is available to untrusted PR workflows.

## Before deployment / update
- [ ] Artifact provenance/signature is verified before extraction or execution.
- [ ] Installer/update source is pinned and authenticated; no mutable branch bootstrap.
- [ ] Privileges are minimized and external values are validated.
- [ ] Concurrent updates are serialized and downgrade policy is explicit.
- [ ] Health check, backup, and rollback behavior are tested.
- [ ] Logs avoid secrets and sensitive data.

## Automated enforcement
- [ ] `security-policy` is a required status check in the default-branch ruleset.
- [ ] `security-exceptions.json` is present and validated in CI; no expired or unapproved exceptions.
- [ ] Required CI checks cannot be skipped by path filters or conditional job logic.
- [ ] Release publication depends on successful artifact attestation generation; deployment depends on successful verification.

## Ongoing
- [ ] Dependency and vulnerability scans run on a schedule.
- [ ] Alerts have an owner and remediation target.
- [ ] Recovery/rollback procedures are periodically exercised.
- [ ] Threat model and exceptions are reviewed after material changes and at least annually.
