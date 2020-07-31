## Fabric 2.0 Lab Environment

### 0. Prepare

```bash
############### common packages ####################
# install utilities
sudo apt-get install -y apt-transport-https ca-certificates software-properties-common 
sudo apt-get install -y unzip git  curl wget vim tree jq

# install gradle
cd /tmp && wget https://services.gradle.org/distributions/gradle-6.4-bin.zip
unzip gradle-6.4-bin.zip
sudo mv gradle-6.4 /usr/local/gradle
sudo cat >> ~/.bashrc <<EOF
# setup gradle environments
# =====================
export PATH=$PATH:/usr/local/gradle/bin
# =====================
EOF
source ~/.bashrc 

# download workspace from gitlab.com
git clone https://gitlab.com/qubing/blockchain_lab_v2.git ~/workspace

############### docker ####################
# import docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable"

# update repository index & install docker-ce
sudo apt-get update & sudo apt-get install -y docker-ce

# check docker version
docker -v
# check docker image list (only root can use docker by default)
docker images
# enable  current user to use docker (!!! need to re-login via terminal !!!)
sudo gpasswd -a ${USER} docker
# check docker image list
docker images

#Tips: Speed up docker hub access in China
sudo cat >> /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": ["https://registry.docker-cn.com"] 
}
EOF
sudo systemctl daemon-reload 
sudo systemctl restart docker

############### docker images ####################
# image of ca
docker pull hyperledger/fabric-ca:1.4.6
# image of peer
docker pull hyperledger/fabric-peer:2.1.0
# image of orderer
docker pull hyperledger/fabric-orderer:2.1.0
# image of tools & utilities
docker pull hyperledger/fabric-tools:2.1.0
# image of Chaincode deployment for Programming Languages (Go | Java | Node.JS)
docker pull hyperledger/fabric-ccenv:2.1.0
docker pull hyperledger/fabric-javaenv:2.1.0
docker pull hyperledger/fabric-nodeenv:2.1.0
# image of Base-OS of Chaincode runtime
docker pull hyperledger/fabric-baseos:0.4.20
# image of coucddb (one NOSQL DB for ledger state)
docker pull hyperledger/fabric-couchdb:0.4.20

# check image list to validate downloading
docker images

############### docker-compose ####################
# download
#wget https://github.com/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` 
#wget https://get.daocloud.io/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m`
wget https://blockchain-files.s3.cn-northwest-1.amazonaws.com.cn/docker-compose-`uname -s`-`uname -m`
# copy to ` /usr/local/bin/ ` and rename
sudo mv docker-compose-`uname -s`-`uname -m` /usr/local/bin/docker-compose
# make executable
sudo chmod +x /usr/local/bin/docker-compose
# validate installation
docker-compose -v

############### programming languages ####################
# install Go
cd /tmp && wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.4.linux-amd64.tar.gz
sudo cat >> ~/.bashrc <<EOF
# setup go environments
# =====================
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/gopath 
export GO111MODULE=on 
export GOPROXY=https://goproxy.cn
# =====================
EOF
source ~/.bashrc
go version

# install Java
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
java -version

# install `nvm`
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
# validate installation of `nvm`
nvm --version
# install Node.JS version 10
nvm install 10
# check the version of Node.JS and NPM
node -v
npm -v
```

### BlockChain start
```shell script
./initBlockChain.sh
```




