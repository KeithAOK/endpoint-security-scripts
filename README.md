\# endpoint-security-scripts



A collection of endpoint security detection and remediation scripts for use in enterprise environments. Scripts are organized by category and include deployment guidance for JumpCloud and JAMF MDM platforms.



These scripts are derived from real-world security operations work and are intended to support security practitioners, IT administrators, and GRC professionals in maintaining visibility and control over managed endpoints.



\---



\## Repository Structure
endpoint-security-scripts/

├── ai-tooling/

│   └── detect-gemini-nano/     # Detect silently installed AI model weights on managed endpoints

├── browser-security/           # Browser configuration and policy detection scripts

└── mdm-deployment/

├── jumpcloud/              # JumpCloud custom command deployment guidance

└── jamf/                   # JAMF policy deployment guidance

---



\## Usage



Each script directory contains a README.md with context, compliance relevance, and deployment instructions, along with platform-specific scripts (.sh for macOS/Linux, .ps1 for Windows).



Scripts are designed to be run via MDM custom command deployment against managed device fleets. Output is captured in the MDM console for review.



\---



\## Compliance Context



These scripts support evidence collection and control validation for the following frameworks:



\- \*\*SOC 2 Type II\*\* - CC6.1, CC6.8, CC7.1

\- \*\*PCI DSS v4.0.1\*\* - Requirement 5.1, 6.3, 11.5

\- \*\*NIST CSF\*\* - DE.CM: Continuous monitoring of endpoints

\- \*\*ISO 27001\*\* - A.12.6, A.14.2: Vulnerability management and secure development



\---



\## Author



Keith Oquelí | Security Operations Manager, GRC



