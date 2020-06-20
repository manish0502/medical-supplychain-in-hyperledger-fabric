echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo
echo

set -e
echo
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
set -x
./bin/configtxgen -profile hackerthonGenesis -channelID mychannel -outputBlock ./channel-artifacts/genesis.block
set +x
echo
echo "####################################################################"
echo "### Generating channel configuration transaction 'CV_Channel.tx' ###"
echo "####################################################################"
./bin/configtxgen -profile CV_Channel -outputCreateChannelTx ./channel-artifacts/CV_Channel.tx -channelID cvchannel
set +x
echo
echo "#################################################################"
echo "#######    Generating anchor peer update for KeralakalamandalamMSP   ##########"
echo "#################################################################"
set -x
./bin/configtxgen -profile CV_Channel -outputAnchorPeersUpdate ./channel-artifacts/distributorMSP_CV_Channelanchors.tx -channelID cvchannel -asOrg distributorMSP
set +x
echo
echo "#################################################################"
echo "#######    Generating anchor peer update for StudentMSP   ##########"
echo "#################################################################"
set -x
./bin/configtxgen -profile CV_Channel -outputAnchorPeersUpdate ./channel-artifacts/manufacturerMSP_CV_Channelanchors.tx -channelID cvchannel -asOrg manufacturerMSP
set +x
echo
echo "######################################################################"
echo "#######    Generating anchor peer update for VerifierMSP   ##########"
echo "#####################################################################"
set -x
./bin/configtxgen -profile CV_Channel -outputAnchorPeersUpdate ./channel-artifacts/retailerMSP_CV_Channelanchors.tx -channelID cvchannel -asOrg retailerMSP
set +x
echo
echo "###############################################"
echo "#######    Booting up the network    ##########"
echo "###############################################"
docker-compose -f ./docker-compose-cli.yaml up -d
echo
echo "##########################################################"
echo "#######    Running containers of the network   ##########"
echo "#########################################################"
docker ps -a
echo "#######   sleeping 15 seconds for cluster to be ready    ##########"
sleep 15
echo
echo "#####################################################################"
echo "#######   Entering cli container and running script.sh    ##########"
echo "####################################################################"
docker exec cli bash scripts/script.sh

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo


