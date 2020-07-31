#!/bin/bash
. scripts/utils.sh

echo '######## - (COMMON) setup variables - ########'
setupCommonENV
if [[ $# -ge 1 ]]; then
    export CC_NAME=$1
fi
setupPeerENV2

set -x
if [[ "$CORE_PEER_TLS_ENABLED" == "true" ]]; then
    peer chaincode invoke \
    -o ${ORDERER_ADDRESS} --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
    $CC_ENDORSERS \
    -C $CHANNEL_NAME -n ${CC_NAME}  \
    --isInit -c '{"Function":"InitChainCode","Args":[]}'
    $CC_ENDORSERS
else
    peer chaincode invoke \
    -o ${ORDERER_ADDRESS} \
    $CC_ENDORSERS \
    -C $CHANNEL_NAME -n ${CC_NAME}  \
    --isInit -c '{"Function":"InitChainCode","Args":[]}'
fi
set +x