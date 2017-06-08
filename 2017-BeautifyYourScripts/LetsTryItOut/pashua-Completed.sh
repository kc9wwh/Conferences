#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# Let's Try it Out - Pashua
#
# In this example we want to create a Pashua dialog box to prompt the
# end-user to let them know of an available update.
#
#
# OBJECTIVES
#       - Create Pashua dialog box to notify user of available update
#       - Provide details (i.e., S/W Name, Version, Reboot Required)
#       - Allow user to choose to install now or later
#
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# SCRIPT PARAMETERS:
#           $4 - Software Name
#           $5 - Software Version
#           $6 - Required By
#           $7 - Reboot Required
#           $8 - Estimated Time Required
#           $9 - Self Service Link
#
# i.e., "" "" "" "Microsoft Office 2016" "15.36.0" "June 9th" "No" "10 Min" "selfservice://"
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

pashuaLocation="/usr/local/jamfps"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# FUNCTIONS - DO NOT MODIFY
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

##Function for communicating with Pashua
pashua_run() {

    # Write config file
    local pashua_configfile=`/usr/bin/mktemp /tmp/pashua_XXXXXXXXX`
    echo "$1" > "$pashua_configfile"

    local bundlepath="Pashua.app/Contents/MacOS/Pashua"
    pashuapath="$pashuaLocation/$bundlepath"

    # Get result
    local result=$("$pashuapath" "$pashua_configfile")

    # Remove config file
    rm "$pashua_configfile"

    oldIFS="$IFS"
    IFS=$'\n'

    # Parse result
    for line in $result
    do
        local name=$(echo $line | sed 's/^\([^=]*\)=.*$/\1/')
        local value=$(echo $line | sed 's/^[^=]*=\(.*\)$/\1/')
        eval $name='$value'
    done

    IFS="$oldIFS"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# PASHUA DIALOG BOXES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

updatePrompt="
# Set window title
*.title = Acme Corporation - Information Technology

logo.type = image
logo.x = 180
logo.y = 230
logo.maxwidth = 250
logo.path = $pashuaLocation/acme2.png

selfserv.type = image
selfserv.x = 0
selfserv.y = 160
selfserv.maxwidth = 50
selfserv.path = /Applications/Self Service.app/Contents/Resources/Self Service.icns

# Software Info
swInfo.type = text
swInfo.default = Software Name: $4[return]Software Version: $5[return][return]Required By: $6[return]Reboot Required: $7[return]Est. Time Required: $8
swInfo.width = 300
swInfo.x = 60
swInfo.y = 107

# Message
txt.type = text
txt.default = You have an available software update![return][return]The latest verison of $4 is ready to be installed. Please ensure you save all your work if a reboot is required. To run this update now, please click the Install Now button.[return][return]If you have any questions or need assistance, please contact the Help Desk.
txt.width = 300
txt.x = 320
txt.y = 60

# Install Now Button
installButton.type = defaultbutton
installButton.label = Install Now

# Remind Me Tomorrow Button
remindButton.type = button
remindButton.label = Remind Me Tomorrow
"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

## Display Dialog to End User
/bin/echo "Waiting for user input..."
pashua_run "$updatePrompt"

## Which Button Was Clicked
if [[ $remindButton == 1 ]]; then
    /bin/echo "User choose to be reminded tomorrow..."
    exit 0
else
    if [[ $installButton == 1 ]]; then
        /bin/echo "User choose to install now..."
        /bin/echo "Launching Self Service and Executing Install for $4 $5..."
        sudo -u ${userName} /usr/bin/open "$9"
    fi
fi

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# CLEANUP & EXIT
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

/bin/echo "Done."
exit 0