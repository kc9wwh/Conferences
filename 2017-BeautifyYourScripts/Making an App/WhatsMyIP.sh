#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# Copyright (c) 2016, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# WhatsMyIP.sh will show the users current Local, External and VPN IP Addresses.
#
#
# Written by: Joshua Roskos | Professional Services Engineer | JAMF Software
#
# Created On: August 9th, 2016
# Updated On: December 1st, 2016
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# USER DEFINED VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

orgName="Acme Corporation"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# SYSTEM VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

ifen0=$( ifconfig en0 | awk '$1 == "inet" {print $2}' )
externalIP1=$( dig +short myip.opendns.com @resolver1.opendns.com )
externalIP2=$( curl -s ifconfig.me )
utun0=$( ifconfig utun0 | awk '$1 == "inet" {print $2}' )
cdPath="/usr/local/jamfps/CocoaDialog.app/Contents/MacOS/CocoaDialog"
networkIcon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericNetworkIcon.icns"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# check if en0 is blank
if [[ $ifen0 != "" ]]; then
	myLocalIP=${ifen0}
else
	ifen1=$( ifconfig en1 | awk '$1 == "inet" {print $2}' )
	# check if en1 is blank
	if [[ $ifen1 != "" ]]; then
		myLocalIP=${ifen1}
	else
		ifen2=$( ifconfig en2 | awk '$1 == "inet" {print $2}' )
		# check if en2 is blank
		if [[ $ifen2 != "" ]]; then
			myLocalIP=${ifen2}
		else
			ifen3=$( ifconfig en3 | awk '$1 == "inet" {print $2}' )
			# check if en3 is blank
			if [[ $ifen3 != "" ]]; then
				myLocalIP=${ifen3}
			else
				ifen4=$( ifconfig en4 | awk '$1 == "inet" {print $2}' )
				# check if en4 is blank
				if [[ $ifen4 != "" ]]; then
					myLocalIP=${ifen4}
				else
					ifen5=$( ifconfig en5 | awk '$1 == "inet" {print $2}' )
					# check if en5 is blank
					if [[ $ifen5 != "" ]]; then
						myLocalIP=${ifen5}
					else
						ifen6=$( ifconfig en6 | awk '$1 == "inet" {print $2}' )
						# check if en6 is blank
						if [[ $ifen6 != "" ]]; then
							myLocalIP=${ifen6}
						else
							ifen7=$( ifconfig en7 | awk '$1 == "inet" {print $2}' )
							# check if en7 is blank
							if [[ $ifen7 != "" ]]; then
								myLocalIP=${ifen7}
							else
								ifen8=$( ifconfig en8 | awk '$1 == "inet" {print $2}' )
								# check if en8 is blank
								if [[ $ifen8 != "" ]]; then
									myLocalIP=${ifen8}
								else
									ifen9=$( ifconfig en9 | awk '$1 == "inet" {print $2}' )
									# check if en9 is blank
									if [[ $ifen9 != "" ]]; then
										myLocalIP=${ifen9}
									else
										myLocalIP="No IP Address Found!"
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi
fi

# check if externalIP1 is blank
if [[ $externalIP1 != "" ]]; then
	myExternalIP=${externalIP1}
else
	# check if externalIP2 is blank
	if [[ $externalIP2 != "" ]]; then
		myExternalIP=${externalIP2}
	else
		myExternalIP="No IP Address Found!"
	fi
fi

# check if utun0 is blank
if [[ $utun0 != "" ]]; then
	myVPNIP=${utun0}
else
	utun1=$( ifconfig utun1 | awk '$1 == "inet" {print $2}' )
	# check if utun1 is blank
	if [[ $utun1 != "" ]]; then
		myVPNIP=${utun1}
	else
		utun2=$( ifconfig utun2 | awk '$1 == "inet" {print $2}' )
		# check if utun2 is blank
		if [[ $utun2 != "" ]]; then
			myVPNIP=${utun2}
		else
			utun3=$( ifconfig utun3 | awk '$1 == "inet" {print $2}' )
			# check if utun3 is blank
			if [[ $utun3 != "" ]]; then
				myVPNIP=${utun3}
			else
				utun4=$( ifconfig utun4 | awk '$1 == "inet" {print $2}' )
				# check if utun4 is blank
				if [[ $utun4 != "" ]]; then
					myVPNIP=${utun4}
				else
					utun5=$( ifconfig utun5 | awk '$1 == "inet" {print $2}' )
					# check if utun5 is blank
					if [[ $utun5 != "" ]]; then
						myVPNIP=${utun5}
					else
						utun6=$( ifconfig utun6 | awk '$1 == "inet" {print $2}' )
						# check if utun6 is blank
						if [[ $utun6 != "" ]]; then
							myVPNIP=${utun6}
						else
							utun7=$( ifconfig utun7 | awk '$1 == "inet" {print $2}' )
							# check if utun7 is blank
							if [[ $utun7 != "" ]]; then
								myVPNIP=${utun7}
							else
								utun8=$( ifconfig utun8 | awk '$1 == "inet" {print $2}' )
								# check if utun8 is blank
								if [[ $utun8 != "" ]]; then
									myVPNIP=${utun8}
								else
									utun9=$( ifconfig utun9 | awk '$1 == "inet" {print $2}' )
									# check if utun9 is blank
									if [[ $utun9 != "" ]]; then
										myVPNIP=${utun9}
									else
										myVPNIP="No IP Address Found!"
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi
fi

# check if Organization Name is blank
if [[ ${orgName} != "" ]]; then
	title="${orgName} | Whats My IP?"
else
	title="Whats My IP?"
fi

text=$( echo -e "Local IP: \t\t${myLocalIP}\nExternal IP: \t${myExternalIP}\nVPN IP: \t\t ${myVPNIP}" )
"${cdPath}" ok-msgbox --title "${title}" --icon-file "${networkIcon}" --text "IP Addresses Found" --informative-text "${text}" --no-cancel --float

exit 0