set -e
echo "===================== Channel 'cvchannel' created ===================== "
echo
set -x
peer channel create -o orderer0.certverification.com:7050 -f ./channel-artifacts/CV_Channel.tx -c cvchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/certverification.com/orderers/orderer0.certverification.com/msp/tlscacerts/tlsca.certverification.com-cert.pem
set +x
sleep 3

echo "===================== peer0.keralakalamandalam joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Updating anchor peers for keralakalamandalam..."
echo
set -x
peer channel update -o orderer0.certverification.com:7050 -f ./channel-artifacts/Keralakalamandalam_Channelanchors.tx -c cvchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/certverification.com/orderers/orderer0.certverification.com/msp/tlscacerts/tlsca.certverification.com-cert.pem
set +x
sleep 3

echo "Installing chaincode on peer0.keralakalamandalam..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/certificate/javascript/
set +x
sleep 3

export CORE_PEER_LOCALMSPID=KeralakalamandalamMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/keralakalamandalam.certverification.com/peers/peer1.keralakalamandalam.certverification.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/keralakalamandalam.certverification.com/users/Admin@keralakalamandalam.certverification.com/msp
export CORE_PEER_ADDRESS=peer1.keralakalamandalam.certverification.com:8051

echo "===================== peer1.keralakalamandalam joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Installing chaincode on peer1.keralakalamandalam..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/certificate/javascript/
set +x
sleep 3

export CORE_PEER_LOCALMSPID=StudentMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/student.certverification.com/peers/peer1.student.certverification.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/student.certverification.com/users/Admin@student.certverification.com/msp
export CORE_PEER_ADDRESS=peer1.student.certverification.com:10051

echo "===================== peer1.student joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Installing chaincode on peer1.student..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/certificate/javascript/
set +x
sleep 3

export CORE_PEER_LOCALMSPID=StudentMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/student.certverification.com/peers/peer0.student.certverification.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/student.certverification.com/users/Admin@student.certverification.com/msp
export CORE_PEER_ADDRESS=peer0.student.certverification.com:9051

echo "===================== peer0.student joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Updating anchor peers for student..."
echo
set -x
peer channel update -o orderer0.certverification.com:7050 -f ./channel-artifacts/Student_Channelanchors.tx -c cvchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/certverification.com/orderers/orderer0.certverification.com/msp/tlscacerts/tlsca.certverification.com-cert.pem
set +x
sleep 3

echo "Installing chaincode on peer0.student..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/certificate/javascript/
set +x
sleep 3


export CORE_PEER_LOCALMSPID=VerifierMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/verifier.certverification.com/peers/peer1.verifier.certverification.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/verifier.certverification.com/users/Admin@verifier.certverification.com/msp
export CORE_PEER_ADDRESS=peer1.verifier.certverification.com:12051

echo "===================== peer1.verifier joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Installing chaincode on peer1.verifier..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/certificate/javascript/
set +x
sleep 3

export CORE_PEER_LOCALMSPID=VerifierMSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/verifier.certverification.com/peers/peer0.verifier.certverification.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/verifier.certverification.com/users/Admin@verifier.certverification.com/msp
export CORE_PEER_ADDRESS=peer0.verifier.certverification.com:11051

echo "===================== peer0.verifier joined channel 'cvchannel' ===================== "
echo
set -x
peer channel join -b cvchannel.block
set +x
sleep 3

echo "Updating anchor peers for verifier..."
echo
set -x
peer channel update -o orderer0.certverification.com:7050 -f ./channel-artifacts/Verifier_Channelanchors.tx -c cvchannel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/certverification.com/orderers/orderer0.certverification.com/msp/tlscacerts/tlsca.certverification.com-cert.pem
set +x
sleep 3

echo "Installing chaincode on peer0.verifier..."
echo
set -x
peer chaincode install -n certcc -l node -v 1.0 -p /opt/gopath/src/github.com/chaincode/certificate/javascript/
set +x
sleep 3

echo "Instantiating chaincode on peer0.verifier..."
echo
set -x
peer chaincode instantiate -o orderer0.certverification.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/certverification.com/orderers/orderer0.certverification.com/msp/tlscacerts/tlsca.certverification.com-cert.pem -C cvchannel -n certcc -l node -v 1.0 --collections-config /opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/privateDataCollection.json -c '{"Args":[]}' -P "OR ('KeralakalamandalamMSP.peer')"
set +x
sleep 3

exit 0