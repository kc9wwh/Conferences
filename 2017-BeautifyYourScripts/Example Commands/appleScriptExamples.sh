##
## Beautifying Your Scripts | From Script to App
## Josh Roskos, Professional Services Engineer - Jamf
##
## MacDeployment Conference - University of Calgary
## June 8th & 9th 2017
## 

##
## Apple Script Examples
##

## Display Dialog
/usr/bin/osascript -e 'Tell application "System Events" to display dialog "Display Dialog with text."'

## Display Dialog - Add Title
/usr/bin/osascript -e 'Tell application "System Events" to display dialog "Display Dialog with text." with title "Acme Corporation - Information Technology"'

## Display Dialog - Add Title - Single Button
/usr/bin/osascript -e 'Tell application "System Events" to display dialog "Display Dialog with text." with title "Acme Corporation - Information Technology" with text buttons {"OK"}'

## Display Dialog - Add Title - Multiple Buttons - Specify Default
/usr/bin/osascript -e 'Tell application "System Events" to display dialog "Display Dialog with text." with title "Acme Corporation - Information Technology" with text buttons {"Lets Go", "Stop"} default button "Stop"'

## Display Dialog - Add Icons
## Icon options 0, 1 or 2
/usr/bin/osascript -e 'Tell application "System Events" to display dialog "Display Dialog with text." with title "Acme Corporation - Information Technology" with icon 0 with text buttons {"Lets Go", "Stop"} default button "Stop"'

## Text Field
/usr/bin/osascript -e 'Tell application "System Events" to display dialog "Enter your Username:" default answer "" with title "Acme Corporation - Information Technology" with text buttons {"OK"} default button 1' -e 'text returned of result'

## Hidden Text Field
/usr/bin/osascript -e 'Tell application "System Events" to display dialog "Enter your Password:" default answer "" with hidden answer with title "Acme Corporation - Information Technology" with text buttons {"OK"} default button 1' -e 'text returned of result'

## Capture input as variable
varName="$( {insert osascript here} )"