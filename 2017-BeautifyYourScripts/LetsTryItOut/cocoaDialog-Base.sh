#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# Let's Try it Out - CocoaDialog
#
# In this example we want to create a CocoaDialog dialog box to prompt the
# end-user for their password to reissue a FileVault Keyw
#
#
# OBJECTIVES
#       - Create CocoaDialog dialog box to get users password
#       - Store password as variable "userPass"
#
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

cdPath="/usr/local/jamfps/CocoaDialog.app/Contents/MacOS/CocoaDialog"   #CocoaDialog Location
logo="/usr/local/jamfps/acme2.png"                                      #Company Logo
userName=$(/usr/bin/stat -f%Su /dev/console)                            #Get the logged in user's name
userID=$(/usr/bin/id -u ${userName})                                    #Get the logged in user's UID
OS=`/usr/bin/sw_vers -productVersion | awk -F. {'print $2'}`            #Get the OS version

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

## This first user check sees if the logged in account is already authorized with FileVault 2
userCheck=`fdesetup list | awk -v usrN="$userName" -F, 'index($0, usrN) {print $1}'`
if [ "${userCheck}" != "${userName}" ]; then
    echo "This user is not a FileVault 2 enabled user."
    exit 3
fi

## Check to see if the encryption process is complete
encryptCheck=`fdesetup status`
statusCheck=$(echo "${encryptCheck}" | grep "FileVault is On.")
expectedStatus="FileVault is On."
if [ "${statusCheck}" != "${expectedStatus}" ]; then
    echo "The encryption process has not completed."
    echo "${encryptCheck}"
    exit 4
fi

## Get the logged in user's password via a prompt
echo "Prompting ${userName} for their login password."

# <-------------- START WORK HERE -------------->

userPass="$(  )"



# <-------------- END WORK HERE -------------->

echo "Issuing new recovery key"
if [[ $OS -ge 9  ]]; then
    ## This "expect" block will populate answers for the fdesetup prompts that normally occur while hiding them from output
    expect -c "
    log_user 0
    spawn fdesetup changerecovery -personal
    expect \"Enter a password for '/', or the recovery key:\"
    send "{${userPass}}"
    send \r
    log_user 1
    expect eof
    " >> /dev/null
else
    echo "OS version not 10.9+ or OS version unrecognized"
    echo "$(/usr/bin/sw_vers -productVersion)"
    exit 5
fi

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# CLEANUP & EXIT
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

exit 0