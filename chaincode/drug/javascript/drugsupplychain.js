"use strict";

const { Contract } = require("fabric-contract-api");
// const ClientIdentity = require('fabric-shim').ClientIdentity;
class Drugchain extends Contract {
    async init(ctx){
        console.info("Chaincode Instantiated");
    }

    async createPackage(
        ctx,
        batchNo,
        productName,
        productType,
        quantity,
        humiduty,
        temperature,
        sellerName,
        sellerGST,
        buyerName,
        buyerGST,
        transpoterName,
        vehicleNo
    ) {
        let owner = ctx.stub.getCreator();
        if(owner.mspid === "manufacturerMSP"){
            let packageDetails = {
                batchNo,
                productName,
                productType,
                quantity,
                humiduty,
                temperature,
                sellerName,
                sellerGST,
                buyerName,
                buyerGST,
                transpoterName,
                vehicleNo,
                owner: "manufacture",
                paymentDate: new Date().getFullYear(),
                status: "created",
                updatedBy: "manufacture",
                payment: false
            };
            try {
                await ctx.stub.putState(
                    packageDetails.batchNo,
                    Buffer.from(JSON.stringify(packageDetails))
                );
                return(JSON.stringify({response:"The package is created successfully!!!"}));
            } catch (error) {
                throw new Error(
                    "package is not created this the error faced in creating: " +
                        error
                );
            }
        }
        else{
            throw new Error(`${owner.mspid} is not allowed to create a package`);
        }
    }

    async updatePackageDistributer(ctx, batchNo, sellerName, sellerGST, buyerName, buyerGST, temperature, humiduty, transpoterName, vehicleNo) {
        try {
            const packageAsBytes = await ctx.stub.getState(batchNo);
            if (!packageAsBytes || packageAsBytes.length === 0) {
                throw new Error(`package with ${batchNo} does not exist`);
            }
            let packageDetails = JSON.parse(packageAsBytes.toString());
            packageDetails.status = "shipment in progress";
            packageDetails.sellerName = sellerName;
            packageDetails.sellerGST = sellerGST;
            packageDetails.buyerName = buyerName;
            packageDetails.buyerGST = buyerGST;
            packageDetails.temperature = temperature;
            packageDetails.humiduty = humiduty;
            packageDetails.transpoterName = transpoterName;
            packageDetails.vehicleNo = vehicleNo;
            try {
                await ctx.stub.putState(
                    packageDetails.batchNo,
                    Buffer.from(JSON.stringify(packageDetails))
                );
                return(JSON.stringify({response:"The package data is updated by transpoter !!!"}));
            } catch (error) {
                throw new Error(
                    "package data is not updated this the error faced in creating: " +
                        error
                );
            }
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

    async updatePackageRetailer(ctx, batchNo,temperature, humiduty, transpoterName, vehicleNo) {
        try {
            const packageAsBytes = await ctx.stub.getState(batchNo);
            if (!packageAsBytes || packageAsBytes.length === 0) {
                throw new Error(`package with ${batchNo} does not exist`);
            }
            let packageDetails = JSON.parse(packageAsBytes.toString());
            packageDetails.status = "recieved";
            packageDetails.temperature = temperature;
            packageDetails.humiduty = humiduty;
            packageDetails.transpoterName = transpoterName;
            packageDetails.vehicleNo = vehicleNo;
            try {
                await ctx.stub.putState(
                    packageDetails.batchNo,
                    Buffer.from(JSON.stringify(packageDetails))
                );
                return(JSON.stringify({response:"The package data is updated by retailer!!!"}));
            } catch (error) {
                throw new Error(
                    "package data is not updated this the error faced in creating: " +
                        error
                );
            }
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

    async viewPackage(ctx, querystring) {
        try {
            const resultIterator = await ctx.stub.getQueryResult(querystring);
            const packages = [];
            while(true) {
                let res = await resultIterator.next();
                if(res.value && res.value.toString()) {
                    let packageDetails = {};
                    packageDetails.Key = res.value.Key;
                    packageDetails.Record = JSON.parse(res.value.value.toString("utf8"));
                    packages.push(packageDetails);
                }
                if (res.done) {
                    await resultIterator.close();
                    return packages;
                }
            }
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

}

module.exports = Drugchain;
