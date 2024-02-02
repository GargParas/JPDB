# $1 dockerImageName
# $2 data folder for which the volume is to be set from the jpdb data folder running under docker image inside docker container.
# $3 is port to be explosed from docker container.

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

if [ -f "runtime-config.properties" ]
then
echo "runtime-config.properties file exists"
else
touch runtime-config.properties
echo "jpdb.threshold.ram.check=true" >> runtime-config.properties
echo "jpdb.threshold.ram.warning=0.65" >> runtime-config.properties
echo "jpdb.threshold.ram.error=0.85" >> runtime-config.properties
echo "jpdb.ram.check.time=2" >> runtime-config.properties
chmod a+rwx runtime-config.properties
fi

if [ -f "config.properties" ]
then
echo "config.properties file exists"
else
touch config.properties
echo "jpdb.port=$3" >> config.properties
echo "jpdb.maxThread=128" >> config.properties
echo "jpdb.corsOrigin=*" >> config.properties
echo "jpdb.corsMethods=*" >> config.properties
echo "jpdb.corsHeaders=*" >> config.properties
echo "jpdb.staticFilePath=../bin/public_html" >> config.properties
echo "jpdb.default.gmail.smtp.host=smtp.gmail.com" >> config.properties
echo "jpdb.default.gmail.smtp.port=465" >> config.properties
echo "jpdb.default.gmail.smtp.login=noreply.login2xplore@gmail.com" >> config.properties
echo "jpdb.default.gmail.smtp.appPassword=hgcrpbwwcnbuqafd" >> config.properties
echo "jpdb.keystoreFilePath=./ssl.jks" >> config.properties
echo "jpdb.keystorePassword=pw#l2x05" >> config.properties
echo "jpdb.truststoreFilePath=" >> config.properties
echo "jpdb.truststorePassword=" >> config.properties
chmod a+rwx config.properties
fi

#Running the Container
#sudo docker run --restart=always -p $3:$3 -v $(pwd)/:/home/jpdb/data $1 &
#sudo docker run -p $3:$3 -v $(pwd):/home/jpdb/data $1 &
sudo docker run -m 1400m --memory-swap 2800m -p $3:$3 -v $(pwd):/home/jpdb/data $1 &
