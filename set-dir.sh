sudo apt-get update
sudo apt-get upgrade

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

cd $home
mkdir jpdb
cd jpdb

wget https://raw.githubusercontent.com/GargParas/JPDB/main/jpdb-setup.sh

chmod jpdb-setup.sh 755

./jpdb-setup.sh parasgargl2x/jpdb-openjdk8-2gb data 5577

