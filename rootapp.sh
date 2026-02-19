#! /bin/bash
ROOTAPP="$HOME/Applications/rootapp/Root.AppImage"
ROOTAPPDIR="$HOME/Applications/rootapp"
ROOTDESKTOP="$HOME/Desktop/Root.desktop"
ROOTICON="$HOME/Applications/rootapp/rooticon.ico"

# Check to see if root.app has been installed if it has not been install root app
if [ -f "$ROOTAPPDIR/install.txt" ]; then
kdialog --icon "$ROOTICON" --title "Rootapp Uninstall" --yes-label "Uninstall" --no-label "Launch Rootapp" --yesno "Would you like to uninstall rootapp?"
    case "$?" in
        0)
            cd $HOME/Applications;
            rm -rf rootapp;
            rm $ROOTDESKTOP;
            echo "$?";
            kdialog --title "Rootapp Uninstaller" --msgbox "Rootapp has been uninstalled";
            exit;
            ;;
        1)
            $ROOTAPP;
            ;;
    esac;
else
kdialog --title "Rootapp Installer" --yes-label "Install" --no-label "Close" --yesno "Welcome to Kookykoala's Rootapp Installer.<br><br>This script will download the offical rootapp AppImage<br> install and create a desktop icon for the Root chat.<br><br>Will install at $ROOTAPPDIR<br><br>"
    if [ $? = 0 ]; then
        progress=$(kdialog --progressbar "Install" 5);
        echo "Installing";
        qdbus $progress Set "" value 1 > /dev/null;
        qdbus $progress setLabelText "Creating directories" > /dev/null;
            if [ -d "$HOME/Applications" ]; then
                echo "$HOME/Applications does exist"
            else
                echo "Making applications directory.."
                mkdir $HOME/Applications
            fi
            echo "Checking to see if rootapp directory exist"
            if [ -d "$ROOTAPPDIR" ]; then
            echo "Rootapp directory exist"
            else
            echo "Making rootapp directory"
            mkdir $ROOTAPPDIR
            fi
        cp rootapp.sh $ROOTAPPDIR/rootapp.sh
        cd $ROOTAPPDIR
        chmod +x rootapp.sh
        qdbus $progress Set "" value 2 > /dev/null;
        qdbus $progress setLabelText "Downloading Rootapp" > /dev/null;
        echo "Downloading root"
        wget https://installer.rootapp.com/installer/Linux/X64/Root.AppImage
        chmod +x $ROOTAPP
        qdbus $progress Set "" value 3 > /dev/null;
        qdbus $progress setLabelText "Extracting icons" > /dev/null;
        $ROOTAPP --appimage-extract
        cp $ROOTAPPDIR/squashfs-root/usr/bin/rooticon.ico $ROOTAPPDIR/rooticon.ico
        qdbus $progress Set "" value 4 > /dev/null;
        qdbus $progress setLabelText "Creating desktop entry" > /dev/null;
        # Make Desktop App Icon
        echo "[Desktop Entry]" > $ROOTDESKTOP
        echo "Exec=$ROOTAPP" >> $ROOTDESKTOP
        echo "Icon=$ROOTAPPDIR/rooticon.ico" >> $ROOTDESKTOP
        echo "Name=Root" >> $ROOTDESKTOP
        echo "Terminal=false" >> $ROOTDESKTOP
        echo "Type=Application" >> $ROOTDESKTOP
        chmod +x $ROOTDESKTOP
        qdbus $progress Set "" value 5 > /dev/null;
        qdbus $progress setLabelText "Cleaning up..." > /dev/null;
        rm -rf $ROOTAPPDIR/squashfs-root
        touch install.txt
        qdbus $progress close > /dev/null;
        kdialog --title "Rootapp Installer" --yes-label "Launch Root" --no-label "Close"  --yesno "Rootapp has been installed, would you like to launch it Root?<br>If you wish to uninstall please run rootapp.sh in the install directory."
            if [ $? = 0 ]; then
                $ROOTAPP
            else
                exit
            fi
        else
            exit
        fi
fi
exit
