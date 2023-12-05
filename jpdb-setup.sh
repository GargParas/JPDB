
# $1 dockerImageName
# $2 data folder for which the volume is to be set from the jpdb data folder running under docker image inside docker container.
# $3 is port to be explosed from docker container.

PORT_CHECK=$(sudo lsof -i -P -n | grep :$3)
n=${#PORT_CHECK}

PORT_CHECK=$(sudo lsof -i -P -n | grep :$3)
n=${#PORT_CHECK}

#PORT CHECK, whether a particular port is open or not for use
if [ $n -ne 0 ]
then
 echo "Port is already in Use"
 exit
else
 echo "Port is Open for Use"
fi

#Folder Check
if [ -d "$2" ]
then
  echo "$2 Folder Exists"
  if [ -f "$2/jpdbsys/jpdb.on" ]
  then
     echo "Already One Instance is using this Folder. Use another Folder or stop the current JPDB Instance."
     exit
  fi
else
  mkdir $2
  chmod -R a+rwx $2
  echo "$2 Folder Created"
fi

#PULL Image from Docker Hub, if not available locally
sudo docker pull $1

cd $2

touch config.properties
echo "jpdb.port=$3" > config.properties
echo "jpdb.maxThread=32" >> config.properties
echo "jpdb.corsOrigin=*" >> config.properties
echo "jpdb.corsMethods=*" >> config.properties
echo "jpdb.corsHeaders=*" >> config.properties
echo "jpdb.staticFilePath=../bin/public_html" >> config.properties
echo "#" >> config.properties
echo "# jpdb.maxThread=32" >> config.propertiesin;2
echo "#" >> config.properties

#Check if .jks file exists
if [ -f "ssl.jks" ]
then
   echo "jpdb.keystoreFilePath=ssl.jks" >> config.properties
   echo "jpdb.keystorePassword=Dits1HKD" >> config.properties
   echo "jpdb.truststoreFilePath=" >> config.properties
   echo "jpdb.truststorePassword=" >> config.properties
else
   echo "# jpdb.keystoreFilePath=ssl.jks" >> config.properties
   echo "# jpdb.keystorePassword=Dits1HKD" >> config.properties
   echo "# jpdb.truststoreFilePath=" >> config.properties
   echo "# jpdb.truststorePassword=" >> config.properties
fi

chmod a+rwx config.properties

#Running the Container
#sudo docker run --restart=always -p $3:$3 -v $(pwd)/:/home/jpdb/data $1 &
sudo docker run -p $3:$3 -v $(pwd):/home/jpdb/data $1 &

