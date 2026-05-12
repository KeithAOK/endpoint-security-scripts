\# JumpCloud Deployment Guide



Guidance for deploying endpoint-security-scripts via JumpCloud Custom Commands.



\## Prerequisites



\- JumpCloud administrator access

\- JumpCloud agents active on target devices

\- APNs certificate valid and current (required for macOS MDM command delivery)



\## Deploying a Custom Command



1\. Log into the JumpCloud Admin Console

2\. Navigate to Device Management in the left navigation, select 'Commands' from the cascade menu.

3\. Click 'New Command'

4\. Select the target platform: Mac, Windows, or Linux

5\. Paste the script content

6\. Configure Run As: select root. The script handles user context switching internally.

7\. Optionally, set a Schedule for recurring execution

8\. Apply to 'All Devices' or a specific Device Group

9\. Click 'Save' and 'Run Now' to execute immediately



\## Reviewing Results



After execution navigate to Device Management, Commands, then Results to view per device output. Click View Details next to each command to see the \*\*\**stdout\*\*\**, \*\*\**stderr\*\*\**, and \*\*\**exit code\*\*\** for each device.



\## Supported Platforms



JumpCloud supports custom command deployment to the following platforms:



\- macOS

\- Windows

\- Linux: Ubuntu LTS, RHEL, CentOS, Rocky Linux, Fedora, Mint, Pop!\_OS, Amazon Linux



\## Notes



\- Scripts that check paths under $HOME or %LOCALAPPDATA% must run as the current user, not as root or SYSTEM

\- JumpCloud agent must be active and checking in for commands to reach the device

\- For macOS devices confirm the APNs MDM certificate is valid before deploying

\- Linux scripts require bash and are compatible with all JumpCloud supported distributions

\- The Gemini Nano weights.bin file resides inside a version subdirectory under \*\*\*OptGuideOnDeviceModel\*\*\* and the detection script uses find to locate it dynamically regardless of version number

