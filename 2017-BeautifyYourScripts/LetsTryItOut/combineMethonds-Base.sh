#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# Let's Try it Out - Pashua & CocoaDialog
#
# In this example we want to use Pashua and CocoaDialog to create a great end-user
# experience by using Pashua to display a single user display box that will ask all the 
# required info and then use CocoaDialog to create a progress bar to show progress of
# DEP enrollment workflow including installing applications.
#
#
# OBJECTIVES
#       - Create Pashua dialog box with:
#           - At least 1 textfield
#           - At least 2 popups
#       - Allow user to verify computer name is right and if not, re-enter the pashua info
#       - Create CocoaDialog progress bar to show status of configuration & app installs
#       - Have at least 5 "dummy" apps install (example below)
#               /bin/echo "20 Installing Application 1..." >&3
#               /bin/echo "Installing Application 1..."
#               /bin/sleep 1
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

pashuaLocation="/usr/local/jamfps"
cdLocation="/usr/local/jamfps/CocoaDialog.app/Contents/MacOS/CocoaDialog"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# FUNCTIONS
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

firstRun="
# Set window title
*.title = Acme Corporation - Information Technology


"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# RENAME COMPUTER
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# INSTALL BASE APPLICATIONS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

##Installing Application 1
/bin/echo "20 Installing Application 1..." >&3
/bin/echo "Installing Application 1..."
/bin/sleep 3



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# CLEANUP & EXIT
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


exit 0