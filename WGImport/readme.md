Kookykoala's Wireguard Import Scripts, is a universal GUI / Commandline import script for KDE desktop enviroments and should work on most distrobutions using KDE and Network Manager

This script was built to give a simple GUI way to import wireguard .conf files as Network Manager GUI does not have an easy way to import a config file, and well then it snowballed. It will install itself, create desktop icon, and launcher icon to launch the kdialog gui.


Command Line Preamerters, added as a proof of concept

-help: Shows this help dialog

"/Path/To/.conf : Will auto load .conf file with autoconnect.no, and not bring up the interface

When path to .conf is used you can use autoconnect/connectnow option
You will need to set autoconnect if you want to use -connectnow option
    -autoconnect.yes : Will set Interface to Autoconnect
    -autoconnect.no : Will set Interface to not Autoconnect
    -connectnow : Will bring Interface up
