#! /bin/bash
INSTALLED=no
DONTINSTALL=no
WGISH="$HOME/Scripts/WGImport/WGImport.sh"
WGIDESKTOP="$HOME/Desktop/Wireguard_Import.desktop"
ICON="$HOME/Scripts/WGImport/wireguard.png"
INSCRIPTTXT="Wireguard import script, you will be prompted to choose a file<br>please choose your Wireguard .conf file.<br>Make sure your config is only upercase, lowercase, and - to avoid errors"
INAUTOTXT="has been imported you can connect using the networkmanager gui. Would you like to connect now?"
# Wireguard Install
if [ $INSTALLED = "yes" ]; then
  echo "Installed"
  else
  if [ $DONTINSTALL = "no" ]; then
  echo "Not Installed"
  kdialog --title "Wireguard Script Installer" --yes-label "Install" --no-label "Dont Install" --cancel-label "Don't Ask"  --yesnocancel "Would you like to install to $HOME/Scripts/WGImport/<br> Clicking Don't Ask, Will not ask you to install this script again."
  case "$?" in
        0)
          echo "Installing";
          if [ -d "$HOME/Scripts" ]; then
            echo "Script directory, exist"
          else
            echo "Making Script dicretory"
            mkdir $HOME/Scripts
          fi
          if [ -d "$HOME/Scripts/WGImport" ]; then
            echo "WGImport Exist"
            kdialog --title "Wireguard Install" --error "Wireguard directory exist<br>$HOME/Scrpits/WGimport<br>dPlease Delete this directory to reinstall"
            exit
          else
            mkdir $HOME/Scripts/WGImport;
            WGINSTALLDIR="$HOME/Scripts/WGImport";
            cp WGImport.sh $WGINSTALLDIR/WGImport.sh;
            cd $WGINSTALLDIR;
            wget "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/wireguard.png";
            echo "[Desktop Entry]" > $WGIDESKTOP;
            echo "Exec=$WGISH" >> $WGIDESKTOP;
            echo "Icon=$WGINSTALLDIR/wireguard.png" >> $WGIDESKTOP;
            echo "Name=Wireguard Import" >> $WGIDESKTOP;
            echo "Terminal=false" >> $WGIDESKTOP;
            echo "Type=Application" >> $WGIDESKTOP;
            echo "Setting Veriables";
            chmod +x $WGIDESKTOP;
            sed -i "s/^INSTALLED=.*/INSTALLED=yes/" $WGISH;
            sed -i "s/^DONTINSTALL=.*/DONTINSTALL=yes/" $WGISH;
            echo "Installer Ran";
            $WGISH;
            exit;
          fi
            ;;
        1)
            ;;
        2)
            sed -i "s/^DONTINSTALL=.*/DONTINSTALL=yes/" WGImport.sh;
            ;;
        *)
          exit;
          ;;
    esac;
    fi
fi
# Show the Message box to start import
kdialog  --icon "$ICON" --title "Wireguard Import" --msgbox "$INSCRIPTTXT"
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
#Completed message, ask if auto connect should be enabled.
        kdialog --icon "$ICON" --title "Wireguard Import" --yesno "Would you like to Auto Connect, $VAR2"
          if [ $? = 1 ]; then
            nmcli connection modify $VAR2 connection.autoconnect no
          fi
        kdialog --icon "$ICON" --title "Wireguard Import" --yes-label "Connect" --no-label "Close" --yesno "$VAR2 $INAUTOTXT"
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
