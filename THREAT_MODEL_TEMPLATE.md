# Threat model: <project>

- **Tier:** Basic / Standard / Critical
- **Owner:**
- **Last reviewed:**
- **Next review:**

## System and data
Describe components, deployment topology, data classification, secrets, and external dependencies.

## Trust boundaries and entry points
List users, APIs, webhooks, files, package registries, CI workflows, deployment agents, and privileged interfaces.

## Threat scenarios
| Asset | Threat / abuse case | Impact | Likelihood | Mitigation | Verification |
|---|---|---|---|---|---|
| | | | | | |

Consider at least:
- credential theft and secret leakage;
- dependency, build, artifact, and update supply-chain compromise;
- unauthorized access and privilege escalation;
- malicious or malformed input;
- replay, downgrade, and concurrent update attacks;
- data exposure through logs, backups, or telemetry;
- CI workflow injection and untrusted pull-request execution.

## Security decisions
Record authentication/authorization, secrets handling, network exposure, runtime privileges, release verification, and recovery design.

## Residual risks and exceptions
Link to `SECURITY_EXCEPTIONS.md`. Every exception needs an owner and expiry date.

## Review
Record reviewer, date, findings, and follow-up issues.
