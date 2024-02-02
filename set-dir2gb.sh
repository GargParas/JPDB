
# $1 is port and create variable $2 will be 'jpdb'+$1
# if $2 exist then error "JsonPowerDB folder exists; seems its already running" and exit
# if $1 is in use then error "$1 port is in occupied; please use different port" and exit
# How to run this script: ./set-dir-new port_no

PORT_CHECK=$(sudo lsof -i -P -n | grep :$1)
n=${#PORT_CHECK}

#PORT CHECK, whether a particular port is open or not for use
if [ $n -ne 0 ]
then
 echo "Port is already in Use. Please use different port."
 exit
else
 echo "Port is Open for Use"
fi

folderName="jpdb${1}"
echo "${folderName}"

sudo apt-get update 
sudo apt-get upgrade 

# sudo apt-get install \
#     ca-certificates \
#     curl \
#     gnupg \
#     lsb-release

# sudo mkdir -p /etc/apt/keyrings

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 

# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# sudo apt-get update 
# sudo apt-get upgrade 

# sudo apt-get install docker-ce docker-ce-cli containerd.io
# sudo docker run hello-world

cd $home
mkdir $folderName
cd $folderName

if [ -f "jpdb-setup.sh" ]
then
echo "jpdb-setup.sh file exists"
else
wget https://raw.githubusercontent.com/GargParas/JPDB/main/jpdb-setup.sh
chmod 755 jpdb-setup.sh
fi

# login2explore/jpdb032-openjdk8-2gb:1 is the docker-image-name and :1 is the docker-image-version
# The following line executes another script i.e. jpdb-setup.sh
./jpdb-setup.sh login2explore/jpdb032-openjdk8-2gb:1 data $1
