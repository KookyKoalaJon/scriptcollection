#! /bin/bash
ICON=$HOME/Scripts/wireguard.png
# Wireguard Install
# Show the Message box to start import
kdialog --icon "$ICON" --title "Wireguard Import" --msgbox "Wireguard import script, you will be prompted to choose a file<br>please choose your Wireguard config file.<br>Make sure your config is only upercase, lowercase, and - to avoid errors"
# Check for ok, if not exit progam
  if [ $? = 0 ]; then
    # Select config file, set VAR1 for input
    VAR1=$(kdialog --icon "$ICON" --title "Choose Wireguard config" --getopenfilename $HOME/Downloads ;)
      if [ $? = 0 ]; then
# Import file using Network Manager
        nmcli connection import type wireguard file "$VAR1"
# Set VAR2, using basename commmad to strip the name and extension off the imported file
        VAR2=$(basename $VAR1 .conf)
# Bring down the network connection for wireguard connection
        nmcli connection down $VAR2
#Completed message, ask if user would like to connect.
        kdialog --icon "$ICON" --title "Wireguard Import" --yes-label "Connect" --no-label "Close" --yesno "Wireguard Config has been imported you can connect using the netowrk gui. Would you like to connect now?"
# Check if Connect was pressed if so bring interface up if not close.
        if [ $? = 0 ]; then
          nmcli connection up $VAR2
        else
          exit
        fi
      else
        exit
      fi
  else
    exit
  fi
