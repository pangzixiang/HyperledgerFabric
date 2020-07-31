#!/bin/bash
./teardown.sh
. ./init.sh


. scripts/deploy_chaincode.sh java ${PWD}/chaincode/mychaincode mychaincode


java -classpath BlockChainUserRegister-1.0-SNAPSHOT-jar-with-dependencies.jar register.EnrollAdmin
java -classpath BlockChainUserRegister-1.0-SNAPSHOT-jar-with-dependencies.jar register.RegisterUser


./initSellerChainCode.sh mychaincode
./initBuyerChainCode.sh mychaincode
./initPlatformChainCode.sh mychaincode