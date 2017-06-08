#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

pashuaLocation="/usr/local/jamfps"

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

demoDialog="
# Set window title
*.title = Acme Corporation - Information Technology

logo.type = image
logo.maxwidth = 250
logo.path = $pashuaLocation/acme2.png

tx.type = textfield
tx.label = textfield
tx.default = default text
tx.width = 250

chk.type = checkbox
chk.label = Please check the checkbox...

cb.type = combobox
cb.label = Sample combobox
cb.default = Red
cb.option = Red
cb.option = Yellow
cb.option = Blue
cb.option = Green

d.type = date
d.label = Example date

opb.type = openbrowser
opb.label = Select a file:

txt.type = text
txt.default = Text with returns...[return][return]...and more text

pw.type = password
pw.label = Please enter your password:
pw.width = 160

p.type = popup
p.label = Example popup
p.width = 200
p.option = Red
p.option = Yellow
p.option = Blue
p.option = Green

radio.type = radiobutton
radio.label = Exmaple Radiobuttons
radio.option = Yes
radio.option = No

# Default Button
defaultbutton.type = defaultbutton

# Cancel Button
cancelbutton.type = cancelbutton
"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

## Display Dialog to End User
pashua_run "$demoDialog"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# CLEANUP & EXIT
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

exit 0