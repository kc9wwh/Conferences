##
## Beautifying Your Scripts | From Script to App
## Josh Roskos, Professional Services Engineer - Jamf
##
## MacDeployment Conference - University of Calgary
## June 8th & 9th 2017
## 

##
## CocoaDialog Script Examples
##

## Declare CocoaDialog Variables
cdPath="/usr/local/jamfps/CocoaDialog.app/Contents/MacOS/CocoaDialog"
cdTitle="Acme Corporation - Information Technology"

## ok-msgbox
${cdPath} ok-msgbox --title "${cdTitle}" --text "Welcome to Acme Corporation." --informative-text "Please let us know if there is anything we can do to make your employment more enjoyable." --no-cancel --icon-file "/usr/local/jamfps/acme.png" --float

## standard-inputbox
${cdPath} standard-inputbox --title "${cdTitle}" --informative-text "Please enter your Department:" 

## secure-inputbox
${cdPath} secure-standard-inputbox --title "${cdTitle}" --informative-text "Please enter your password:" 
${cdPath} standard-inputbox --title "${cdTitle}" --informative-text "Please enter your password:" --no-show

## fileselect
${cdPath} fileselect --title "${cdTitle}" --text "Please select a file to import" --with-extensions .plist --with-directory /Library/Preferences/

## filesave
${cdPath} filesave --title "${cdTitle}" --with-directory ~/

## textbox
${cdPath} textbox --title "${cdTitle}" --informative-text "Please read and agree before proceeding..." --button1 "Agree" --text "Welcome to Acme Corporation. 

Everything you think off, touch, create and so forth are propety of Acme Corporation. 

If you can catch the road runner, you will be promoted to COO and recieve a substantial reward.


Love,
Legal"

## standard-dropdown
${cdPath} standard-dropdown --title "${cdTitle}" --text "Have you ever left toontown?" --items "Yes" "No" "Maybe" "Not Sure" --no-cancel

## progressbar (indeterminate)
${cdPath} progressbar --title "${cdTitle}" --indeterminate --text "Preparing files for backup..." --float

## progressbar
#### sets up pipe to pass percentage and description
/bin/rm -f /tmp/hpipe
/usr/bin/mkfifo /tmp/hpipe
#### creates initial progress bar dialog
${cdPath} progressbar --title "${cdTitle}" --text "Preparing files for backup..." --percent 0 --float < /tmp/hpipe &
exec 3<> /tmp/hpipe
#### send updates via echo command (Number is percentage / 0-100)
/bin/echo "10 Backing up Preferences..." >&3
/bin/echo "20 Backing up Desktop..." >&3
/bin/echo "30 Backing up Documents..." >&3
/bin/echo "40 Backing up Music..." >&3
/bin/echo "50 Backing up Photos..." >&3
/bin/echo "60 Backing up Movies..." >&3
/bin/echo "80 Veriying Backup Integrity..." >&3
/bin/echo "90 Compressing Backup..." >&3
/bin/echo "100 Backup Complete" >&3
#### kills progress bar and clean up pipe
exec 3>&-
wait
/bin/rm -f /tmp/hpipe

## Capture input as variable
varName="$( {insert cocoadialog here} )"