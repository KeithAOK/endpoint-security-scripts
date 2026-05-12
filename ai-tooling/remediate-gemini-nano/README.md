# remediate-gemini-nano

Removes Google Chrome's silently installed Gemini Nano AI model weights and applies persistent enterprise policy settings to prevent re-download on managed endpoints.

## Origin

This repository content was derived from an internal security advisory issued by Second Nature Security Operations on May 11, 2026. Scripts and remediation logic have been sanitized and generalized for public use.

## Background

Google Chrome silently downloads a 2.6GB to 4.3GB AI model called Gemini Nano without user consent. The model resides in a versioned subdirectory under OptGuideOnDeviceModel within each user's Chrome profile. Deleting the file alone is insufficient as Chrome re-downloads it automatically on the next restart unless enterprise policy settings are applied.

These scripts remove the existing model weights and apply persistent policy settings that survive Chrome updates.

## Files

| File | Platform | Description |
|------|----------|-------------|
| remediate_gemini_nano.sh | macOS | Removes weights.bin and applies Chrome managed preference policy |
| remediate_gemini_nano.ps1 | Windows | Removes weights.bin and applies registry policy |

## Remediation Approach

Two actions are required for persistent remediation:

1. **Delete** the existing weights.bin file and its parent version directory
2. **Apply policy** to prevent Chrome from re-downloading the model on restart

Without both steps the remediation is temporary.

## Compliance Relevance

| Framework | Control | Relevance |
|-----------|---------|-----------|
| SOC 2 Type II | CC6.8 | Controls to prevent unauthorized software |
| PCI DSS v4.0.1 | 6.3, 11.5.2 | Removal of unapproved components from system |
| NIST CSF | RS.MI-3 | Newly identified vulnerabilities mitigated or documented as accepted risk |
| ISO 27001 | A.12.6 | Management of technical vulnerabilities |
| NYDFS Part 500 | 500.14 | Monitoring and remediation of unauthorized software |

## Usage

Deploy via JumpCloud Custom Command. See mdm-deployment/jumpcloud/README.md for deployment instructions.

Run detection scripts first to confirm presence before deploying remediation.

## Important Notes

- **macOS:** Deploy via JumpCloud as root. The script handles user context switching internally.
- **Windows:** Deploy via JumpCloud as SYSTEM. SYSTEM privileges are required to write to HKLM registry keys. Running locally requires PowerShell launched as administrator.
- The file deletion step succeeds with standard user privileges. The registry policy step requires elevated privileges.
- The script reports policy applied regardless of success or failure. This will be addressed in a future version.

## Expected Output

If remediation succeeds:

REMEDIATED: Gemini Nano weights.bin removed on HOSTNAME
POLICY:     Chrome policy applied to prevent re-download

If file was not found:

NOT FOUND: Gemini Nano weights.bin not present on HOSTNAME
No action taken.

## References

- detect-gemini-nano detection scripts: ../detect-gemini-nano/
- PureInfoTech: Stop Chrome Gemini Nano download on Windows 11
- Chrome developer pages: Built-in AI documentation