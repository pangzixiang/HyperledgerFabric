#!/bin/bash
. ./setup.sh

echo "0.Initialize"
mkdir -p ${PWD}/tmp
mkdir -p organizations/fabric-ca/buyer
mkdir -p organizations/fabric-ca/seller
mkdir -p organizations/fabric-ca/platform
mkdir -p organizations/fabric-ca/ordererOrg
cp organizations/fabric-ca/ca.buyer.example.com.yaml organizations/fabric-ca/buyer/fabric-ca-server-config.yaml
cp organizations/fabric-ca/ca.seller.example.com.yaml organizations/fabric-ca/seller/fabric-ca-server-config.yaml
cp organizations/fabric-ca/ca.platform.example.com.yaml organizations/fabric-ca/platform/fabric-ca-server-config.yaml
cp organizations/fabric-ca/ca.orderer.example.com.yaml organizations/fabric-ca/ordererOrg/fabric-ca-server-config.yaml
echo

echo "1.Startup CA Services in Network"
CA_IMAGE_TAG=${CA_VERSION} docker-compose -f docker/docker-compose-ca.yaml up -d
echo

sleep 5

echo "2.Register Peers and Orderer with users"
. organizations/fabric-ca/registerEnroll.sh 
createBuyer
createSeller
createPlatform
createOrderer
echo

echo "3.Create orderer.genesis.block"
. scripts/utils.sh
setupCommonENV
export FABRIC_CFG_PATH=${PWD}/configtx
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/$CHANNEL_NAME.tx -channelID $CHANNEL_NAME
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/buyerMSPanchors.tx -channelID $CHANNEL_NAME -asOrg buyerMSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/sellerMSPanchors.tx -channelID $CHANNEL_NAME -asOrg sellerMSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/platformMSPanchors.tx -channelID $CHANNEL_NAME -asOrg platformMSP
echo

echo "4.Startup Peers and Orderer"
COMPOSE_FILE_BASE=docker/docker-compose-ABC.yaml
COMPOSE_FILE_COUCH=docker/docker-compose-couch.yaml
IMAGE_TAG=${FABRIC_VERSION} BASE_TAG=${OTHER_VERSION} DB_IMAGE_TAG=${OTHER_VERSION} docker-compose -f ${COMPOSE_FILE_BASE} -f ${COMPOSE_FILE_COUCH} up -d
echo

sleep 5

echo "5.Create & Join Channel"
. scripts/setup_channel.sh
echo

echo "6.Generate Connection Profiles"
./organizations/ccp-generate.sh
if [ ! -d "${PWD}/profiles/buyer/tls" ]; then 
    mkdir -p profiles/buyer/tls
fi
if [ ! -d "${PWD}/profiles/seller/tls" ]; then 
    mkdir -p profiles/seller/tls
fi
if [ ! -d "${PWD}/profiles/platform/tls" ]; then 
    mkdir -p profiles/platform/tls
fi

cp ./organizations/peerOrganizations/seller.example.com/connection-seller.json profiles/seller/connection.json
cp ./organizations/peerOrganizations/buyer.example.com/connection-buyer.json profiles/buyer/connection.json
cp ./organizations/peerOrganizations/platform.example.com/connection-platform.json profiles/platform/connection.json
cp ./organizations/peerOrganizations/seller.example.com/ca/ca.seller.example.com-cert.pem profiles/seller/tls/
cp ./organizations/peerOrganizations/buyer.example.com/ca/ca.buyer.example.com-cert.pem profiles/buyer/tls/
cp ./organizations/peerOrganizations/platform.example.com/ca/ca.platform.example.com-cert.pem profiles/platform/tls/

echo

echo "Done."
