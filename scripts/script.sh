set -e
echo "===================== Channel 'cvchannel' created ===================== "
echo
set -x
peer channel create -o orderer0.hackerthon.com:7050 -f ./channel-artifacts/CV_Channel.tx -c cvchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/hackerthon.com/orderers/orderer0.hackerthon.com/msp/tlscacerts/tlsca.hackerthon.com-cert.pem
set +x
sleep 3

echo "===================== peer0.manufacturer joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Updating anchor peers for manufacturer..."
echo
set -x
peer channel update -o orderer0.hackerthon.com:7050 -f ./channel-artifacts/manufacturerMSP_CV_Channelanchors.tx -c cvchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/hackerthon.com/orderers/orderer0.hackerthon.com/msp/tlscacerts/tlsca.hackerthon.com-cert.pem
set +x
sleep 3

echo "Installing chaincode on peer0.manufacturer..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/drug/javascript/
set +x
sleep 3

export CORE_PEER_LOCALMSPID=manufacturerMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.hackerthon.com/peers/peer1.manufacturer.hackerthon.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.hackerthon.com/users/Admin@manufacturer.hackerthon.com/msp
export CORE_PEER_ADDRESS=peer1.manufacturer.hackerthon.com:8051

echo "===================== peer1.manufacturer joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Installing chaincode on peer1.manufacturer..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/drug/javascript/
set +x
sleep 3

export CORE_PEER_LOCALMSPID=distributorMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor.hackerthon.com/peers/peer1.distributor.hackerthon.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor.hackerthon.com/users/Admin@distributor.hackerthon.com/msp
export CORE_PEER_ADDRESS=peer1.distributor.hackerthon.com:10051

echo "===================== peer1.distributor joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Installing chaincode on peer1.distributor..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/drug/javascript/
set +x
sleep 3

export CORE_PEER_LOCALMSPID=distributorMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor.hackerthon.com/peers/peer0.distributor.hackerthon.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor.hackerthon.com/users/Admin@distributor.hackerthon.com/msp
export CORE_PEER_ADDRESS=peer0.distributor.hackerthon.com:9051

echo "===================== peer0.distributor joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Updating anchor peers for distributor..."
echo
set -x
peer channel update -o orderer0.hackerthon.com:7050 -f ./channel-artifacts/distributorMSP_CV_Channelanchors.tx -c cvchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/hackerthon.com/orderers/orderer0.hackerthon.com/msp/tlscacerts/tlsca.hackerthon.com-cert.pem
set +x
sleep 3

echo "Installing chaincode on peer0.distributor..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/drug/javascript/
set +x
sleep 3


export CORE_PEER_LOCALMSPID=retailerMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/retailer.hackerthon.com/peers/peer1.retailer.hackerthon.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/retailer.hackerthon.com/users/Admin@retailer.hackerthon.com/msp
export CORE_PEER_ADDRESS=peer1.retailer.hackerthon.com:12051

echo "===================== peer1.retailer joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Installing chaincode on peer1.retailer..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/drug/javascript/
set +x
sleep 3

export CORE_PEER_LOCALMSPID=retailerMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/retailer.hackerthon.com/peers/peer0.retailer.hackerthon.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/retailer.hackerthon.com/users/Admin@retailer.hackerthon.com/msp
export CORE_PEER_ADDRESS=peer0.retailer.hackerthon.com:11051

echo "===================== peer0.retailer joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Updating anchor peers for retailer..."
echo
set -x
peer channel update -o orderer0.hackerthon.com:7050 -f ./channel-artifacts/retailerMSP_CV_Channelanchors.tx -c cvchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/hackerthon.com/orderers/orderer0.hackerthon.com/msp/tlscacerts/tlsca.hackerthon.com-cert.pem
set +x
sleep 3

echo "Installing chaincode on peer0.retailer..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/drug/javascript/
set +x
sleep 3

echo "Instantiating chaincode on peer0.retailer..."
echo
set -x
peer chaincode instantiate -o orderer0.hackerthon.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/hackerthon.com/orderers/orderer0.hackerthon.com/msp/tlscacerts/tlsca.hackerthon.com-cert.pem -C cvchannel -n certcc -l node -v 1.0 -c '{"Args":[]}' -P "AND ('distributorMSP.peer','retailerMSP.peer','manufacturerMSP.peer')"
set +x
sleep 3

exit 0