#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# Let's Try it Out - AppleScript
#
# In this example we want to create a AppleScript (osascript) dialog box to prompt the
# end-user for the new Computer Name they would like to set.
#
#
# OBJECTIVES
#       - Create Apple script dialog box to get new computer name
#       - Store new computer name as variable "computerName"
#       - Display dialog box if successful or not with result
#
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# <-------------- START INITIAL DISPLAY DIALOG HERE -------------->


#Get Computer Name
computerName="$(/usr/bin/osascript -e 'Tell application "System Events" to display dialog "Enter the desired computer name:" default answer "" with title "Update Computer Name" with text buttons {"OK"} default button 1 with icon 1' -e 'text returned of result')"


# <-------------- END INITIAL DISPLAY DIALOG HERE -------------->


if [[ "${computerName}" == "" ]]; then
    /bin/echo "Computer Name not Entered!, exiting..."
    exit 1
else
    #Set Computer Name
    /bin/echo "Setting Computer Name..."
    #/usr/sbin/scutil --set ComputerName ${computerName}
    if [[ $? == 0 ]]; then
        verifyCompName=$(/usr/sbin/scutil --get ComputerName)
        /bin/echo "    ComputerName Successfully Set to ${verifyCompName}."
    else
        /bin/echo "    Error Setting ComputerName..."
        error=1
    fi
    #/usr/sbin/scutil --set HostName ${computerName}
    if [[ $? == 0 ]]; then
        verifyHostName=$(/usr/sbin/scutil --get HostName)
        /bin/echo "    HostName Successfully Set to ${verifyHostName}."
    else
        /bin/echo "    Error Setting HostName..."
        error=1
    fi
    #/usr/sbin/scutil --set LocalHostName ${computerName}
    if [[ $? == 0 ]]; then
        verifyLocalHostName=$(/usr/sbin/scutil --get LocalHostName)
        /bin/echo "    LocalHostName Successfully Set to ${verifyLocalHostName}."
    else
        /bin/echo "    Error Setting LocalHostName..."
        error=1
    fi
fi

# <-------------- START ERROR CHECKING DISPLAY DIALOG HERE -------------->

if [[ $error == 1 ]]; then
    /usr/bin/osascript -e 'Tell application "System Events" to display dialog "There was an error while trying to reset your computer name." with title "Update Computer Name" with text buttons {"OK"} default button 1 with icon 0'
else
    /usr/bin/osascript -e 'Tell application "System Events" to display dialog "Your computer name was successfully reset." with title "Update Computer Name" with text buttons {"OK"} default button 1 with icon 1'
fi

# <-------------- END ERROR CHECKING DISPLAY DIALOG HERE -------------->

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# CLEANUP & EXIT
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

exit 0