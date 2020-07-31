#!/bin/bash

echo "Clearing"
docker rm -f `docker ps -qa`
docker rmi -f $(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
docker volume prune -f
docker network prune -f

sudo rm -rf system-genesis-block/*.block
sudo rm -rf channel-artifacts
sudo rm -rf organizations/peerOrganizations
sudo rm -rf organizations/ordererOrganizations
sudo rm -rf tmp
sudo rm -rf organizations/fabric-ca/buyer/*
sudo rm -rf organizations/fabric-ca/seller/*
sudo rm -rf organizations/fabric-ca/platform/*
sudo rm -rf organizations/fabric-ca/ordererOrg/*
sudo rm -rf wallet/*