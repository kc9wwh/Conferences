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

img.type = image
img.x = 0
img.y = 470
img.maxwidth = 350
img.path = $pashuaLocation/acme2.png

# Instructions
txt.type = text
txt.default = As part of IT Security standards, we need to rename your computer based on specific information. In order to complete this process, please fill out the information below. During this process we will also bind you computer to Active Directory and begin installing the base software.[return][return]Before proceeding, please ensure this system is connected to the Corporate network.
txt.width = 300
txt.x = 25
txt.y = 310

# Username
userName.type = textfield
userName.label = Username:
userName.mandatory = true
userName.width = 300
userName.x = 25
userName.y = 240

# Hardware Type
hardwareType.type = popup
hardwareType.mandatory = true
hardwareType.label = Hardware Type:
hardwareType.width = 300
hardwareType.default = MacBook 13-inch (M)
hardwareType.option = MacBook 13-inch (M)
hardwareType.option = MacBook Pro 15-inch (MP)
hardwareType.option = MacBook Air (MA)
hardwareType.option = Mac Mini (MM)
hardwareType.option = iMac / Mac Pro (MD)
hardwareType.x = 25
hardwareType.y = 190

# Year of Purchase
purchaseYear.type = popup
purchaseYear.label = System Year of Purchase:
purchaseYear.default = 2017 (17)
purchaseYear.option = 2013 (13)
purchaseYear.option = 2014 (14)
purchaseYear.option = 2015 (15)
purchaseYear.option = 2016 (16)
purchaseYear.option = 2017 (17)
purchaseYear.option = 2018 (18)
purchaseYear.option = 2019 (19)
purchaseYear.option = 2020 (20)
purchaseYear.option = 2021 (21)
purchaseYear.option = 2022 (22)
purchaseYear.option = 2023 (23)
purchaseYear.option = 2024 (24)
purchaseYear.option = 2025 (25)
purchaseYear.option = 2026 (26)
purchaseYear.option = 2027 (27)
purchaseYear.option = 2028 (28)
purchaseYear.option = 2029 (29)
purchaseYear.option = 2030 (30)
purchaseYear.option = 2031 (31)
purchaseYear.option = 2032 (32)
purchaseYear.width = 300
purchaseYear.x = 25
purchaseYear.y = 140

# User Domain
userDomain.type = popup
userDomain.mandatory = true
userDomain.label = User Domain:
userDomain.width = 300
userDomain.default = ACME
userDomain.option = ACME
userDomain.option = ACMECORP
userDomain.x = 25
userDomain.y = 90

# Location
location.type = popup
location.mandatory = true
location.label = User Location:
location.width = 300
location.default = Toontown (T)
location.option = Toontown (T)
location.option = ACME (A)
location.option = Earth (E)
location.option = Moron Mountain (M)
location.option = Porky's Pizza Palace (P)
location.option = Wackyland (W)
location.x = 25
location.y = 40

# OK Button
ok.type = defaultbutton
ok.label = OK
"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# RENAME COMPUTER
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

##Wait for package to finish
/bin/sleep 3

##Setting up Progress Bar
/bin/echo "Preparing Progress Bar..."
/bin/rm -f /tmp/hpipe
/usr/bin/mkfifo /tmp/hpipe
${cdLocation} progressbar --percent "0" --title "Acme Corporation - Information Technology" --text "Preparing..." --float --posX "left" --posY "top" < /tmp/hpipe &
exec 3<> /tmp/hpipe
/bin/sleep 3

cb=1
while [[ ${cb} == 1 ]]; do
    ##Display Dialog to End User
    /bin/echo "0 Waiting for user input..." >&3
    /bin/echo "Waiting for user input..."
    pashua_run "$firstRun"

    ##Check if User Entered Required Data
    if [[ "${userName}" == "" ]]; then
        /bin/echo "User Exited App...No Data to Continue..."
        /bin/echo "Closing progress bar."
        exec 3>&-
        /bin/rm -f /tmp/hpipe
        /bin/echo "Stopping Process..."
        exit 1
    fi

    ##Convert Username to Uppercase
    /bin/echo "Converting UserID to all uppercase..."
    userName=$( /bin/echo "$userName" | perl -ne 'print uc' )

    ##Get Hardware Code
    /bin/echo "1 Verifying Hardware Code..." >&3
    /bin/echo "Verifying Hardware Code..."
    /bin/sleep 1
    hardwareCode=$( /usr/bin/sed 's/.*(\(.*\)).*/\1/' <<< "$hardwareType" )
    /bin/echo "    User Selected Hardware Code: $hardwareCode"

    ##Get Year of Purchase
    /bin/echo "2 Verifying Year of Purchase..." >&3
    /bin/echo "Verifying Year of Purchase..."
    /bin/sleep 1
    purchaseYearCode=$( /usr/bin/sed 's/.*(\(.*\)).*/\1/' <<< "$purchaseYear" )
    /bin/echo "    User Selected Year of Purchase: $purchaseYearCode"

    ##Get Location Code
    /bin/echo "3 Verifying Location Code..." >&3
    /bin/echo "Verifying Location Code..."
    /bin/sleep 1
    locationCode=$( /usr/bin/sed 's/.*(\(.*\)).*/\1/' <<< "$location" )
    /bin/echo "    User Selected Location Code: $locationCode"

    ##Build Computer Name
    /bin/echo "4 Building Computer Name..." >&3
    /bin/echo "Building Computer Name..."
    /bin/sleep 1
    computerName="$userName-$hardwareCode$purchaseYearCode$locationCode"
    /bin/echo "    Computer name will be: $computerName"

    ##Verify Computer Name
    verifyCompName="
    # Set window title
    *.title = Acme Corporation - Information Technology

    img.type = image
    img.x = 0
    img.y = 220
    img.maxwidth = 350
    img.path = $pashuaLocation/acme2.png

    # Instructions
    txt.type = text
    txt.default = Please verify the computer name and domain shown are correct.
    txt.width = 300
    txt.x = 25
    txt.y = 160

    # Computer Name
    compName.type = textfield
    compName.disabled = 1
    compName.label = Computer Name:
    compName.default = $computerName
    compName.mandatory = true
    compName.width = 300
    compName.x = 25
    compName.y = 90

    # Domain
    domain.type = textfield
    domain.disabled = 1
    domain.label = Domain:
    domain.default = $userDomain
    domain.mandatory = true
    domain.width = 300
    domain.x = 25
    domain.y = 40

    # Proceed Button
    ok.type = defaultbutton
    ok.label = Proceed

    # Cancel Button
    cb.type = cancelbutton
    cb.label = Change Data
    "
    /bin/echo "5 Verifying Computer Name..." >&3
    /bin/echo "Verifying Computer Name..."
    /bin/sleep 1
    pashua_run "$verifyCompName"
    if [[ $cb == 0 ]]; then
        /bin/echo "5 Computer Name Verified..." >&3
        /bin/echo "Computer Name Verified...Proceeding..."
    else
        /bin/echo "Computer Name Rejected...Displaying Dialog for New Data..."
    fi
done

##Rename Computer
/bin/echo "7 Setting Computer Name..." >&3
/bin/echo "Setting Computer Name..."
/bin/sleep 3
#/usr/sbin/scutil --set ComputerName $computerName
if [[ $? == 0 ]]; then
    verifyCompName=$(/usr/sbin/scutil --get ComputerName)
    /bin/echo "    ComputerName Successfully Set to ${verifyCompName}."
else
    /bin/echo "    Error Setting ComputerName..."
fi
#/usr/sbin/scutil --set HostName $computerName
if [[ $? == 0 ]]; then
    verifyHostName=$(/usr/sbin/scutil --get HostName)
    /bin/echo "    HostName Successfully Set to ${verifyHostName}."
else
    /bin/echo "    Error Setting HostName..."
fi
#/usr/sbin/scutil --set LocalHostName $computerName
if [[ $? == 0 ]]; then
    verifyLocalHostName=$(/usr/sbin/scutil --get LocalHostName)
    /bin/echo "    LocalHostName Successfully Set to ${verifyLocalHostName}."
else
    /bin/echo "    Error Setting LocalHostName..."
fi
/bin/echo "8 Computer Name Set..." >&3
/bin/echo "    Finished Setting Computer Name..."

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# BIND COMPUTER TO ACTIVE DIRECTORY
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

##Bind to AD
##This command requires that there be a policy established in the JSS for binging to AD
##Said policy must have a custom event trigger of "bindToDomainAcme" or "bindToDomainAcmeCorp"
if [[ ${userDomain} == "ACME" ]]; then
    ##Bind to ACME
    /bin/echo "10 Binding Computer to ACME Domain..." >&3
    /bin/echo "Binding Computer to ACME Domain..."
    /bin/sleep 3
    #/usr/local/bin/jamf policy -event bindToDomainAcme
elif [[ ${userDomain} == "ACMECORP" ]]; then
    ##Bind to ACMECORP
    /bin/echo "10 Binding Computer to ACMECORP Domain..." >&3
    /bin/echo "Binding Computer to ACMECORP Domain..."
    /bin/sleep 
    #/usr/local/bin/jamf policy -event bindToDomainAcmeCorp
fi

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# INSTALL BASE APPLICATIONS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

##Installing Application 1
/bin/echo "20 Installing Application 1..." >&3
/bin/echo "Installing Application 1..."
/bin/sleep 3

##Installing Application 2
/bin/echo "40 Installing Application 2..." >&3
/bin/echo "Installing Application 2..."
/bin/sleep 3

##Installing Application 3
/bin/echo "60 Installing Application 3..." >&3
/bin/echo "Installing Application 3..."
/bin/sleep 3

##Installing Application 4
/bin/echo "70 Installing Application 4..." >&3
/bin/echo "Installing Application 4..."
/bin/sleep 3

##Installing Application 5
/bin/echo "90 Installing Application 5..." >&3
/bin/echo "Installing Application 5..."
/bin/sleep 3

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# CLEANUP & EXIT
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

/bin/echo "95 Submitting Inventory to Jamf Pro..." >&3
/bin/echo "Submitting Inventory to Jamf Pro..."
/bin/sleep 3
#/usr/local/jamf/bin/jamf recon      #Update Inventory with JSS

/bin/echo "98 Setting Reboot..." >&3
/bin/echo "Setting Reboot..."
#/sbin/shutdown -r +1 &

/bin/echo "99 Cleaning up..." >&3
/bin/echo "Cleaning up..."
/bin/sleep 2

/bin/echo "100 Complete..." >&3
/bin/echo "Complete..."
/bin/sleep 2

/bin/echo "Closing progress bar."
exec 3>&-
/bin/rm -f /tmp/hpipe

/bin/echo "Done."
exit 0