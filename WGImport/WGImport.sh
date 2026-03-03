#! /bin/bash
# shellcheck disable=SC2181
source "version"
versionsh=1.0
INSTALLED=no
DONTASK=no
DELDL=yes
WGDEFAULTDIR="$HOME/Scripts/WGImport"
WGINSTALLDIR=""
WGIDESKTOP=""
ICON="$WGINSTALLDIR/wireguard.png"
INSCRIPTTXT="Wireguard import script, you will be prompted to choose a file<br>please choose your Wireguard .conf file.<br>Make sure your config is only uppercase, lowercase, and - with no spaces to avoid errors"
INAUTOTXT="has been imported you can connect using the networkmanager gui. Would you like to connect now?"

# Set Working directoy to where this import script is currently
WGLOCATION=$PWD
echo "versionsh=1.0" >> version
WGIHELP () {
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "xx                         Kooky Koala's Wireguard Import Script.                              xx"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "Command Line Preamerters"
echo " "
echo "-help: Shows this help dialog"
echo "/Path/To/.conf : Will auto load .conf file with autoconnect.no, and not bring up the interface"
echo "When path to .conf is used you can use autoconnect / connectnow option"
echo "You will need to set autoconnect if you want to use -connectnow option"
echo "  -autoconnect.yes : Will set Interface to Autoconnect"
echo "  -autoconnect.no : Will set Interface to not Autoconnect"
echo "    -connectnow : Will bring Interface up"
echo " "
exit 0
}
DESKTOPICON () {
echo "[Desktop Entry]" > "$WGIDESKTOP"
{ echo "Name=Wireguard Import"
  echo "Comment=Import wireguard .conf files into Network Manager"
  echo "Exec=$WGINSTALLDIR/WGImport.sh"
  echo "Icon=$WGINSTALLDIR/wireguard.png"
  echo "Terminal=false"
  echo "Type=Application"
  echo "Categories=Utility"
} >> "$WGIDESKTOP"
chmod +x "$WGIDESKTOP"
desktop-file-install --dir "$HOME/.local/share/applications"  "$WGIDESKTOP"
sleep 2
update-desktop-database "$HOME/.local/share/applications" -v
}
ADDTOMENU () {
kdialog --icon "$ICON" --title "Wireguard Import" --yes-label "Just Launcher Icon" --no-label "Launcher and Desktop" --yesno "Would you like to install to just the launch menu, or Launcher and Desktop Icon."
  case "$?" in
      0)
        WGIDESKTOP="$WGINSTALLDIR/Wireguard_Import.desktop"
        sed -i "s#^WGIDESKTOP=.*#WGIDESKTOP=$WGIDESKTOP#" "$WGINSTALLDIR/WGImport.sh"
        DESKTOPICON
        ;;
      1)
        WGIDESKTOP="$HOME/Desktop/Wireguard_Import.desktop"
        DESKTOPICON
        ;;

      2)
        exit 0
        ;;

esac;
}
WIREIMPORTCLI () {
echo "Importing specified conf file"
echo "$importconf"
nmcli connection import type wireguard file "$importconf"
VAR2=$(basename "$importconf" .conf)
nmcli connection down "$VAR2"

case $2 in
    -autoconnect.no)
        nmcli connection modify "$VAR2" connection.autoconnect no
      ;;
    -autoconnect.yes)
      ;;
    *)
      echo "Autoconnect not specified not auto connecing"
      nmcli connection modify "$VAR2" connection.autoconnect no
      ;;
    esac;
if [ "$3" = "-connectnow" ]; then
  nmcli connection up "$VAR2"
else
  echo "You can bring the interface up in the Network Manager GUI"
  exit 0
fi
exit 0
}
WIREIMPORT () {
kdialog  --icon "$ICON" --title "Wireguard Import" --msgbox "$INSCRIPTTXT"
# Check for ok, if not exit progam
  if [ $? = 0 ]; then
# Select config file, set VAR1 for input
    VAR1=$(kdialog --icon "$ICON" --title "Choose Wireguard config" --getopenfilename "$HOME/Downloads" ;)
      if [ $? = 0 ]; then
# Import file using Network Manager
        nmcli connection import type wireguard file "$VAR1"
# Set VAR2, using basename commmad to strip the name and extension off the imported file
        VAR2=$(basename "$VAR1" .conf)
# Bring down the network connection for wireguard connection
        nmcli connection down "$VAR2"
#Completed message, ask if auto connect should be enabled.
        kdialog --icon "$ICON" --title "Wireguard Import" --yesno "Would you like to Auto Connect, $VAR2"
          if [ $? = 1 ]; then
            nmcli connection modify "$VAR2" connection.autoconnect no
          fi
        kdialog --icon "$ICON" --title "Wireguard Import" --yes-label "Connect" --no-label "Close" --yesno "$VAR2 $INAUTOTXT"
# Check if Connect was pressed if so bring interface up if not close.
        if [ $? = 0 ]; then
          nmcli connection up "$VAR2"
        else
          exit
        fi
      else
        exit
      fi
  else
    exit
  fi
}
WGINSTALLSETUP () {
kdialog --icon "$ICON" --title "Wireguard import installer" --yes-label "Accept Default" --no-label "Choose location" --yesno "Would you like to install Wireguard Import Script to the default location<br>$WGDEFAULTDIR<br>If you choose to install somewhere else please choose an empty directory"
case $? in
  0)
    WGINSTALLDIR=$WGDEFAULTDIR
    echo "Using default directory"
    ;;
  1)
    WGINSTALLDIR=$(kdialog --icon "$ICON" --title "Please Choose a folder to install into" --getexistingdirectory "$HOME" ;)
      if [ $? = 1 ]; then
        exit 1
      fi

      if find "$WGINSTALLDIR" -mindepth 1 -maxdepth 1 | read -r; then
        kdialog --title "Wireguard Import Install" --icon "$ICON" --error "$WGINSTALLDIR<br>Is not an empty directory, please choose an empty directory or empty out choosen directory<br>Exiting srcipt, please relaunch to try again."
        exit 1
      fi
    echo " Wireguard Import is going to be installed at $WGINSTALLDIR"
    ;;
  2)
    exit 1
    ;;
esac;
WIREINSTALL
}
WIREINSTALL () {
  if [ "$WGDEFAULTDIR" = "$WGINSTALLDIR" ]; then
    if [ -d "$HOME/Scripts" ]; then
      echo "Script directory, exist"
    else
      echo "Making Script dicretory"
      mkdir "$HOME/Scripts"
    fi
    if [ -d "$HOME/Scripts/WGImport" ]; then
      echo "WGImport Exist"
      kdialog --title "Wireguard Import Install" --yes-label "Delete" --no-label "Exit" --yesno "WG Import directory exist would you like to delete it?"
        if [ $? = 0 ]; then
          cd "$HOME/Scripts" || { kdialog --title "Wireguard Import Installer" --error "Could not change directory to $HOME/Scripts exiting script"; exit 1; }
          rm -rf WGImport
          rm "$WGIDESKTOP"
          mkdir "$WGINSTALLDIR"
        else
          exit 1
        fi
    else
      mkdir "$WGINSTALLDIR"
    fi
  fi

  cd "$WGLOCATION" || { kdialog --title "Wireguard Import Installer" --error "Could not change script location directory."; exit 1; }
  cp WGImport.sh "$WGINSTALLDIR/WGImport.sh"
  cd "$WGINSTALLDIR" || { kdialog --title "Wireguard Import Installer" --error "Could not change directory to the install directory"; exit 1; }
  wget "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/wireguard.png"
  ADDTOMENU
  sed -i "s#^WGINSTALLDIR=.*#WGINSTALLDIR=$WGINSTALLDIR#" "$WGINSTALLDIR/WGImport.sh"
  sed -i "s/^INSTALLED=.*/INSTALLED=yes/" "$WGINSTALLDIR/WGImport.sh"
  echo "Installer Ran"
  if [ "$DELDL" = "yes" ]; then
   rm "$WGLOCATION/WGImport.sh"
  fi
  kdialog --title "Wireguard Import Install" --icon "$ICON" --yes-label "Start Import Script" --no-label "Close" --yesno "Wireguard Import has been installed to .<br>$WGINSTALLDIR<br>Please launch from launch menu under utilities."
  if [ "$?" = 0 ]; then
    WIREIMPORT
    exit 0
  else
    exit 0
  fi
}


wget -N "https://raw.githubusercontent.com/KookyKoalaJon/scriptcollection/refs/heads/main/WGImport/version"

if [ "$versionsh" ">" "$versionsh" ]; then
  rm WGImport.sh
  wget "https://raw.githubusercontent.com/KookyKoalaJon/scriptcollection/refs/heads/main/WGImport/WGImport.sh"
  chmod +x WGImport.sh
  ./WGImport.sh
fi

case $1 in
  *.conf)
    importconf="$1"
    WIREIMPORTCLI "$@"
  ;;
  -help)
    echo "$version"
    WGIHELP

  ;;
  -addmenu)
    ADDTOMENU
    exit 0
  ;;
  -uninstall)
    if [ "$1" = "-uninstall" ]; then
    if [ "$INSTALLED" = "yes" ]; then
      echo "You have launched the script using $1"
      kdialog --icon "$ICON" --title "Wireguard Import Uninstall" --yes-label "Confirm Uninstall" --no-label "Close" --yesno "Uninstall Wireguard Import Script?"
        if [ $? = 0 ]; then
          rm "$WGIDESKTOP"
          rm "$HOME/.local/share/applications/Wireguard_Import.desktop"
          rm -rf "$WGINSTALLDIR"
          exit 0
        else
          exit 1
        fi
    else
      echo "Not Installed"
      kdialog --icon "$ICON" --title "Wireguard Import Uninstall" --error "Wireguard Import Script, has not been    installed"
      exit 0
    fi
  fi
  ;;
esac;

if [ $DONTASK = yes ]; then
  WIREIMPORT
fi

if [ $INSTALLED = yes ]; then
  WIREIMPORT
else
  kdialog --title "Wireguard Import Installer" --yes-label "Install" --no-label "Don't Ask to Install" --yesno "Would you like to install, the script?<br>If you choose not to you can edit the script and change dontask= to no.<br>Closing the dialog, will launch the import without setting don't ask varible."
    case $? in
    0)
      WGINSTALLSETUP
      ;;
    1)
      sed -i "s/^DONTASK=.*/DONTASK=yes/" WGImport.sh
      WIREIMPORT
      ;;
    2)
      WIREIMPORT
      ;;
    esac;

fi
