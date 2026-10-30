# Security exceptions

No exceptions are approved by default.

For each exception, add a section using this template and remove it when the exception is closed.

## EXC-<ID>: <control>
- **Repository / component:**
- **Control waived:**
- **Reason:**
- **Risk and potential impact:**
- **Compensating control:**
- **Owner:**
- **Approver:**
- **Approved on:**
- **Expires on:**
- **Tracking issue:**
- **Status:** proposed / approved / closed

An exception without an owner, approver, compensating control, or expiry date is not valid. Expired exceptions must be treated as policy violations.

## Machine-readable CI record

Every repository also keeps `security-exceptions.json`. Use an empty array when there are no approved exceptions:

```json
[]
```

An approved exception uses this shape (dates are ISO `YYYY-MM-DD`):

```json
[
  {
    "id": "EXC-001",
    "control": "Describe the waived control",
    "reason": "Why the control cannot currently be met",
    "risk": "Residual risk and impact",
    "compensating_control": "What reduces the risk meanwhile",
    "owner": "Responsible maintainer",
    "approver": "Person who approved the exception",
    "approved_on": "2026-10-30",
    "expires_on": "2027-01-30",
    "tracking_issue": "https://github.com/OWNER/REPO/issues/123",
    "status": "approved"
  }
]
```

The CI validator checks required fields, unique IDs, explicit `approved` status, date format, and expiry. It does not establish that the named approver has authority; enforce that through protected-branch review rules and human review.
