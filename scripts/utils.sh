function setGoCC() {
    export CC_LANG=golang
    export CC_PATH=${PWD}/chaincode/chaincode_example01/go
}

function setupCommonENV() {
    export FABRIC_CFG_PATH=${PWD}/fabric-bin/${FABRIC_VERSION}/config
    export ORDERER_ADDRESS=localhost:7050
    export PEER0_BUYER_ADDRESS=localhost:7051
    export PEER0_SELLER_ADDRESS=localhost:9051
    export PEER0_PLATFORM_ADDRESS=localhost:9100
    export PEER0_BUYER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt
    export PEER0_SELLER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/seller.example.com/peers/peer0.seller.example.com/tls/ca.crt
    export PEER0_PLATFORM_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/platform.example.com/peers/peer0.platform.example.com/tls/ca.crt
    
    export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CHANNEL_NAME=mychannel
}

function setupPeerENV1() {
    export CORE_PEER_LOCALMSPID=buyerMSP
    export CORE_PEER_ADDRESS=$PEER0_BUYER_ADDRESS
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/server.key
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/buyer.example.com/users/Admin@buyer.example.com/msp
}

function setupPeerENV2() {
    export CORE_PEER_LOCALMSPID=sellerMSP
    export CORE_PEER_ADDRESS=$PEER0_SELLER_ADDRESS
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/seller.example.com/peers/peer0.seller.example.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/seller.example.com/peers/peer0.seller.example.com/tls/server.key
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/seller.example.com/peers/peer0.seller.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/seller.example.com/users/Admin@seller.example.com/msp
}

function setupPeerENV3() {
    export CORE_PEER_LOCALMSPID=platformMSP
    export CORE_PEER_ADDRESS=$PEER0_PLATFORM_ADDRESS
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/platform.example.com/peers/peer0.platform.example.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/platform.example.com/peers/peer0.platform.example.com/tls/server.key
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/platform.example.com/peers/peer0.platform.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/platform.example.com/users/Admin@platform.example.com/msp
}