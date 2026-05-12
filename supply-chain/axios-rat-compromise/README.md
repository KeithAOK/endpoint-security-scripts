\## Origin 

This repository content was derived from an internal security advisory issued by Second Nature Security Operations on April 1, 2026 in response to the axios supply chain compromise detected on March 31, 2026. Scripts and detection logic have been sanitized and generalized for public use.



\# axios Supply Chain Compromise - RAT Detection



Detects the presence of malicious axios npm packages delivering a cross-platform Remote Access Trojan (RAT) across managed endpoints.



\## Background



On March 31, 2026 malicious versions of the axios npm package were identified delivering a cross-platform RAT. The compromised versions were:



\- axios v1.14.1

\- axios v0.30.4



These packages were published to the npm registry and could be installed by any project with axios as a dependency. The RAT was cross-platform and capable of executing on macOS, Windows, and Linux.



\## Detection Approach



Detection covers three areas:



1\. **Compromised axios versions** - Checks global npm packages and common project directories for axios v1.14.1 and v0.30.4

2\. **RAT artifacts** - Checks for known platform-specific RAT artifacts left by the malicious payload

3\. **Malicious dependency** - Checks for the presence of plain-crypto-js, the trojanized dependency used to deliver the RAT



\## Confirmed RAT Artifacts



| Platform | Artifact Path |

|----------|--------------|

| macOS | /Library/Caches/com.apple.act.mond |

| Windows | %PROGRAMDATA%\\wt.exe |

| Linux | /tmp/ld.py |



\## Attribution



Microsoft Threat Intelligence has attributed this attack to Sapphire Sleet, a North Korean state-sponsored threat actor. The attack followed a pattern of targeting open source maintainer accounts to achieve broad downstream impact.



\## Exposure Window



The malicious versions were live on npm for approximately 3 hours on March 31, 2026 between 00:21 and 03:25 UTC. Endpoints that ran npm install during this window are considered potentially compromised regardless of whether the package was subsequently updated.

\## Files



| File | Platform | Description |

|------|----------|-------------|

| detect\_axios\_rat.sh | macOS / Linux | Bash script to detect compromised axios versions |

| detect\_axios\_rat.ps1 | Windows | PowerShell script to detect compromised axios versions |



\## Compliance Relevance



| Framework | Control | Relevance |

|-----------|---------|-----------|

| SOC 2 Type II | CC6.8, CC7.1 | Unauthorized software, anomaly detection |

| PCI DSS v4.0.1 | 6.3, 11.5 | Vulnerability management, change detection |

| NIST CSF | DE.CM-4 | Detection of malicious code |

| ISO 27001 | A.12.2 | Protection against malware |

| NYDFS Part 500 | 500.14 | Monitoring and detection |



\## Remediation



If compromised versions are detected:



1\. Immediately isolate the affected endpoint from the network

2\. Run npm list axios in the project directory to confirm the version

3\. Update axios to the latest clean version: npm install axios@latest

4\. Review npm audit output for additional compromised dependencies

5\. Preserve logs and escalate to Security Operations for incident response



\## References



\- Elastic Security Labs: Inside the Axios supply chain compromise, April 1, 2026

\- Microsoft Security Blog: Mitigating the Axios npm supply chain compromise, April 1, 2026

\- StepSecurity: axios Compromised on npm, March 31, 2026

\- SANS Institute: Axios NPM Supply Chain Compromise, April 1, 2026

\- Snyk: Axios npm Package Compromised, March 30, 2026

\- axios GitHub Issue 10636: Post Mortem, April 2, 2026

\- Second Nature Corporate Device Investigation Runbook, April 2026

