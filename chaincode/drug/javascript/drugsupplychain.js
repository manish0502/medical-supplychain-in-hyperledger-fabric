"use strict";

const { Contract } = require("fabric-contract-api");

class Certificate extends Contract {
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
        let package = {
            productName,
            productType,
            quantity,
            humiduty,
            temperature,
            sellerName,
            sellerGST,
            buyerName,
            buyerGST,
            batchNo,
            transpoterName,
            vehicleNo,
            owner: "",
            paymentDate: new Date().getFullYear(),
            status: "created",
            updatedBy: "manufacture",
            payment: false
        };

        try {
            await ctx.stub.putState(
                package.batchNo,
                Buffer.from(JSON.stringify(package))
            );
            return(JSON.stringify({response:"The package is created successfully!!!"}));
        } catch (error) {
            throw new Error(
                "package is not created this the error faced in creating: " +
                    error
            );
        }
    }

    async updatePackage(ctx, batchNo,sellerName,sellerGST,buyerName,buyerGST,temperature,humiduty,transpoterName,vehicleNo) {
        try {
            const packageAsBytes = await ctx.stub.getState(batchNo); // get the car from chaincode state
            if (!packageAsBytes || packageAsBytes.length === 0) {
                throw new Error(`${batchNo} does not exist`);
            }
            let package = JSON.parse(packageAsBytes.toString());
            package.status = "shipment in progress";
            package.sellerName=sellerName,
            package.sellerGST=sellerGST,
            package.buyerName=buyerName,
            package.buyerGST=buyerGST,
            package.temperature=temperature,
            package.humiduty=humiduty,
            package.transpoterName=transpoterName,
            package.vehicleNo=vehicleNo
            try {
                await ctx.stub.putState(
                    package.batchNo,
                    Buffer.from(JSON.stringify(package))
                );
                return(JSON.stringify({response:"The package data is updated successfully!!!"}));
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


    // async viewCertificate(ctx, querystring) {
    //     try {
    //         const resultIterator = await ctx.stub.getQueryResult(querystring);
    //         const certificates = [];
    //         while(true) {
    //             let res = await resultIterator.next();
    //             if(res.value && res.value.toString()) {
    //                 let certificate = {};
    //                 certificate.Key = res.value.Key;
    //                 certificate.Record = JSON.parse(res.value.value.toString("utf8"));
    //                 certificates.push(certificate);
    //             }
    //             if (res.done) {
    //                 await resultIterator.close();
    //                 return certificates;
    //             }
    //         }
    //     } catch (error) {
    //         throw new Error(`Some error has occured ${error}`);
    //     }
    // }

}

module.exports = Certificate;
