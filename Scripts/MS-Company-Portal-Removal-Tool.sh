#!/bin/bash
#created by Kyle Ericson
#Date: Dec 18 2018
#Script to cleanup Company portal for Azure CA via Intune


killall 'JAMF'
echo "quit JAMF"
killall 'Company Portal' 
echo "quit Company Portal"
echo "Remove Company Portal"
rm -R '/Applications/Company Portal.app/'
rm -rf '/Library/Application Support/com.microsoft.CompanyPortal.usercontext.info'
rm -rf '/Library/Application Support/com.jamfsoftware.selfservice.mac'
rm -r '/Library/Saved Application State/com.jamfsoftware.selfservice.mac.savedState' 
rm -r 'Library/Saved Application State/com.microsoft.CompanyPortal.savedState' 
rm -r '/Library/Preferences/com.microsoft.CompanyPortal.plist'
rm -r 'Library/Preferences/com.jamfsoftware.management.jamfAAD.plist' 
rm -r 'Users/$loggedInUser/Library/Cookies/com.microsoft.CompanyPortal.binarycookies' 
rm -r '/Users/$loggedInUser/Library/Cookes/com.jamf.management.jamfAAD.binarycookies'

echo "Remove keychain password items"

security delete-generic-password -l 'com.jamf.management.jamfAAD'
security delete-generic-password -l 'com.microsoft.CompanyPortal'
security delete-generic-password -l 'com.microsoft.CompanyPortal.HockeySDK'
security delete-generic-password -l 'enterpriseregistration.windows.net'

#Replace-with-your-adfs-server-name-FQDN
security delete-generic-password -l 'https://replace-with-your-adfs-server-name-FQDN.com/adfs/ls'
security delete-generic-password -l 'https://replace-with-your-adfs-server-name-FQDN.com/adfs/ls/'
#Replace-with-your-adfs-server-name-FQDN

security delete-generic-password -l 'https://device.login.microsoftonline.com'
security delete-generic-password -l 'https://device.login.microsoftonline.com/' 
security delete-generic-password -l 'https://enterpriseregistration.windows.net' 
security delete-generic-password -l 'https://enterpriseregistration.windows.net/' 
security delete-generic-password -a 'com.microsoft.workplacejoin.thumbprint' 
security delete-generic-password -a 'com.microsoft.workplacejoin.registeredUserPrincipalName' 

removecert=$(security find-certificate -a -Z | grep -B 9 "MS-ORGANIZATION-ACCESS" | grep "SHA-1" | awk '{print $3}')
echo $removecert
security delete-identity -Z $removecert

echo "Install Company Portal"

#replace with your Jamf policy to install Company Portal
/usr/local/bin/jamf policy -event cportal

echo "Run the Azure Registration via Self Service"
exit 0
