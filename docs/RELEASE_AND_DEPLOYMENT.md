# Release, installation, and update security

Applies to Standard and Critical projects. Critical projects must implement every applicable control.

## Release producer
1. Build only from protected source refs in a trusted workflow.
2. Grant `id-token: write` and `attestations: write` only to the release job that creates attestations.
3. Generate a GitHub artifact attestation for every distributable artifact; attest the checksum manifest too if consumers rely on it.
4. Publish immutable versioned artifacts. Tags and release URLs are locators, not proof of authenticity.
5. Record the exact signer workflow and expected repository identity.

## Consumer / installer / updater
1. Download to a staging directory; do not extract, parse as executable content, install, or run it yet.
2. Verify the attestation against the expected repository and signer workflow using GitHub CLI or an equivalent verifier.
3. If using checksums, authenticate the checksum manifest independently. A checksum from the same untrusted source is not an independent trust anchor.
4. Reject mutable branch downloads and unpinned container tags. Prefer versioned artifacts and immutable image digests.
5. Validate external metadata as data; never interpolate it into shell code.
6. Use a dedicated unprivileged account for download and verification. Elevate only the narrow installation step.
7. Serialize updates, enforce anti-downgrade rules, preserve the last known-good version, back up state, health-check, and roll back safely.

The reusable `.github/workflows/release-verification.yml` checks a downloaded file with `gh attestation verify`. The caller must download the file first and supply its path, expected repository, and signer workflow. The verification job needs `attestations: read` and `GH_TOKEN`; it must run before any extraction or execution. Pin the reusable workflow to a full commit SHA.

## Limitations
Attestation verification establishes provenance claims and identity under GitHub's attestation model. It does not prove software is bug-free or benign. Review source, dependencies, workflow permissions, and release protection as well.
