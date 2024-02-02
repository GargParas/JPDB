# $1 is port and create variable $2 will be 'jpdb'+$1
# if $2 exist then error "JsonPowerDB folder exists; seems its already running" and exit
# if $1 is in use then error "$1 port is in occupied; please use different port" and exit

PORT_CHECK=$(sudo lsof -i -P -n | grep :$1)
n=${#PORT_CHECK}

#PORT CHECK, whether a particular port is open or not for use
if [ $n -ne 0 ]
then
 echo "Port is already in Use. Seems its already running."
 exit
else
 echo "Port is Open for Use"
fi

folderName = "jpdb$1"


cd $home
mkdir $folderName
cd $folderName

wget https://raw.githubusercontent.com/GargParas/JPDB/main/jpdb-setup.sh

chmod 755 jpdb-setup.sh

./jpdb-setup.sh login2explore/jpdb032-openjdk8-2gb:1 data $1
