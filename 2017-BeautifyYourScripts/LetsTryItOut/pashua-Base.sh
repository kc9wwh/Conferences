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