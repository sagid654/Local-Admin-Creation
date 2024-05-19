# Local-Admin-Creation

## Description
These PowerShell scripts are designed for use with Microsoft Intune to manage local admin users on Windows devices (For any use / Microsoft LAPS)

- **Detection Script**: Checks if a specified local admin user exists and is a member of the Administrators group.

- **Remediation Script**: Creates a local admin user with a randomly generated password, sets a description, and adds the user to the Administrators group. If the user already exists, it ensures the user is a member of the Administrators group and updates the description.

## Usage

## Parameters
### Detection Script
- `localAdminUserName`: The name of the local admin user to check (default: "LOCALADMINUSERNAME").

### Remediation Script
- `localAdminUserName`: The name of the local admin user to create or update (default: "LOCALADMINUSERNAME").
- `userDescription`: The description to set for the local admin user (default: "DESCRIPTION").

## Deployment through Intune

1. **Save the Script:**
   - Save the PowerShell scripts as `DetectionLocalAdmin.ps1` & `RemediationLocalAdmin.ps1`.

2. **Log in to the Intune Admin Center:**
   - Go to the Microsoft Endpoint Manager admin center.

3. **Create a New Script:**
   - Navigate to `Devices` > `Scripts and remediations` > `Create`.

4. **Upload the Script:**
   - Select `Create` and choose `Windows 10 and later` as the platform.
   - Give the script a name and description.
   - Upload the `DetectionLocalAdmin.ps1` script file to 'Detection script file'.
   - Upload the `RemediationLocalAdmin.ps1` script file to 'Remediation script file'.

5. **Configure Script Settings:**
   - Set the `Script settings` as per your requirements.
   - Ensure `Run this script using the logged on credentials` is set to `No`.

6. **Assign the Script:**
   - Assign the script to the appropriate device groups.

7. **Monitor Script Deployment:**
   - Monitor the deployment status through the Intune admin center.

### Output and Exit Codes

- If local admin is found, the script logs the details and exits with code `0` (detection successful).
- If local admin isn't found, the script logs an appropriate message and exits with code `1` (detection failed).

## Notes

- Customize the script as needed to fit your specific environment and requirements.

## Recommendation
- Try this script in your machine only before deploy it to many devices.

## Disclaimer

This script is provided "as is" without any warranty of any kind, either express or implied, including but not limited to the implied warranties of merchantability and fitness for a particular purpose. The author is not responsible for any damage or issues that may arise from using this script. Use at your own risk.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

**Sagi Dahan**

- GitHub: [github.com/sagid654](https://github.com/sagid654)
- LinkedIn: [linkedin.com/in/sagidahan](https://www.linkedin.com/in/sagidahan/)

For any inquiries or further information, please contact me through GitHub or LinkedIn.

Thank you for using this project. Your feedback and contributions are highly appreciated!
