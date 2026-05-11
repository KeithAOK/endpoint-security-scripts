\# detect-gemini-nano



Detects the presence of Google Chrome's silently installed Gemini Nano AI model weights on managed endpoints.



\## Background



Beginning in approximately April 2026, Google Chrome began silently downloading a 4GB AI model called Gemini Nano to eligible user devices without an explicit consent prompt. The model weights are stored as a file called weights.bin inside a directory called OptGuideOnDeviceModel within the Chrome user profile.



The model re-downloads automatically if deleted unless specific Chrome flags or enterprise policy settings are applied.



\## Confirmed file sizes



\- 1.5GB on lower-specification hardware

\- 2.66GB to 4.27GB on standard and higher-specification hardware



\## Files



| File | Platform | Description |

|------|----------|-------------|

| detect\_gemini\_nano.sh | macOS / Linux | Bash script to detect weights.bin |

| detect\_gemini\_nano.ps1 | Windows | PowerShell script to detect weights.bin |



\## Compliance relevance



| Framework | Control | Relevance |

|-----------|---------|-----------|

| SOC 2 Type II | CC6.8 | Unauthorized software on managed endpoints |

| PCI DSS v4.0.1 | 6.3, 11.5.2 | Unapproved changes to system components |

| NIST CSF | DE.CM-7 | Detection of unauthorized software |

| ISO 27001 | A.12.6 | Management of technical vulnerabilities |



\## Usage



Deploy via JumpCloud Custom Command. See mdm-deployment/jumpcloud/README.md for deployment instructions.



\## Expected output



If present:

FOUND: Gemini Nano weights.bin detected on HOSTNAME

Path: \[file path]

Size: \[file size]



If not present:

NOT FOUND: Gemini Nano weights.bin not present on HOSTNAME

