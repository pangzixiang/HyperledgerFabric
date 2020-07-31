. scripts/utils.sh

echo '######## - (COMMON) setup variables - ########'
setupCommonENV
export CC_NAME=mycc
export CC_VERSION=v1.0
export CC_SEQ=1
export CC_POLICY="OR('buyerMSP.peer', 'sellerMSP.peer', 'platformMSP.peer')"

if [[ $# -ge 2 ]]; then
    if [[ "$1" == "golang" ]]; then
        setGoCC
        echo "Golang CC enabled"
    fi

    if [[ "$1" == "java" ]]; then
        export CC_LANG=java
        echo "Java CC enabled"
    fi

    if [[ "$1" == "node" ]]; then
        export CC_LANG=node
        echo "Node.JS CC enabled"
    fi

    if [[ $# -ge 2 ]]; then
        export CC_PATH=$2
    fi

    if [[ $# -ge 3 ]]; then
        export CC_NAME=$3
    fi

    if [[ $# -ge 4 ]]; then
        export CC_VERSION=$4
    fi

    if [[ $# -ge 5 ]]; then
        export CC_SEQ=$5
    fi

    if [[ $# -ge 6 ]]; then
        export CC_POLICY=$6
    fi
else
    setGoCC
    echo "by default Golang CC enabled"
fi

echo ${CC_PATH}/../collections_config.json

if [[ -f ${CC_PATH}/../collections_config.json ]]; then
    export PRIVATE_COLLECTION_DEF="--collections-config ${CC_PATH}/../collections_config.json"
fi

echo "'CHAINCODE_NAME' set to '$CC_NAME'"
echo "'CHAINCODE_LANG' set to '$CC_LANG'"
echo "'CHAINCODE_PATH' set to '$CC_PATH'"
echo "'CHAINCODE_VERSION' set to '$CC_VERSION'"
echo "'SEQUENCE' set to '$CC_SEQ'"
echo "'PRIVATE_COLLECTION_DEFINITION' set to '${PRIVATE_COLLECTION_DEF}'"

if [[ ! -f tmp/${CC_NAME}_${CC_VERSION}.tar.gz ]]; then
    pushd $CC_PATH
        ./build.sh
    popd
fi

if [[ "$CC_LANG" == "java" ]]; then
    export CC_PATH=$CC_PATH/build/libs
fi

echo '######## - (Seller) install chaincode - ########'
setupPeerENV3
set -x
peer lifecycle chaincode package tmp/${CC_NAME}_${CC_VERSION}.tar.gz --path ${CC_PATH} --lang $CC_LANG --label ${CC_NAME}_${CC_VERSION}
peer lifecycle chaincode install tmp/${CC_NAME}_${CC_VERSION}.tar.gz
set +x

echo '######## - (Seller) approve chaincode - ########'
setupPeerENV3
set -x
# peer lifecycle chaincode queryinstalled >&tmp/log.txt
PACKAGE_ID=$(peer lifecycle chaincode queryinstalled --output json | jq -r '.installed_chaincodes[0].package_id')
set +x

# PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" tmp/log.txt)
echo "PACKAGE_ID(Seller):" ${PACKAGE_ID}
set -x
if [[ "$CORE_PEER_TLS_ENABLED" == "true" ]]; then
    peer lifecycle chaincode approveformyorg \
    -o ${ORDERER_ADDRESS} --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} \
    --init-required --package-id ${PACKAGE_ID} --sequence $CC_SEQ --waitForEvent \
    --signature-policy "$CC_POLICY" \
    $PRIVATE_COLLECTION_DEF
else
    peer lifecycle chaincode approveformyorg \
    -o ${ORDERER_ADDRESS} \
    --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} \
    --init-required --package-id ${PACKAGE_ID} --sequence $CC_SEQ --waitForEvent \
    --signature-policy "$CC_POLICY" \
    $PRIVATE_COLLECTION_DEF
fi
set +x

echo '######## - commit chaincode definition - ########'
setupPeerENV3
set -x
if [[ "$CORE_PEER_TLS_ENABLED" == "true" ]]; then
    peer lifecycle chaincode commit -o ${ORDERER_ADDRESS} --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
    --peerAddresses $PEER0_PLATFORM_ADDRESS --tlsRootCertFiles $PEER0_PLATFORM_TLS_ROOTCERT_FILE \
    -C $CHANNEL_NAME --name ${CC_NAME} \
    --version ${CC_VERSION} --sequence $CC_SEQ --init-required \
    --signature-policy $"$CC_POLICY" \
    $PRIVATE_COLLECTION_DEF
else
    peer lifecycle chaincode commit -o ${ORDERER_ADDRESS} \
    --peerAddresses $PEER0_PLATFORM_ADDRESS \
    -C $CHANNEL_NAME --name ${CC_NAME} \
    --version ${CC_VERSION} --sequence $CC_SEQ --init-required \
    --signature-policy "$CC_POLICY" \
    $PRIVATE_COLLECTION_DEF
fi
set +x