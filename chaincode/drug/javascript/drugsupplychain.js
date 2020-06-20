"use strict";

const { Contract } = require("fabric-contract-api");

class Certificate extends Contract {
    async init(ctx){
        console.info("Chaincode Instantiated");
    }

    async addSemesterMarks(ctx) {
        try{
            let transientSheet = ctx.stub.getTransient();
            let markSheetBuffer = new Buffer(transientSheet.map.markSheet.value.toArrayBuffer());
            let collectionBuffer = new Buffer(transientSheet.map.collection.value.toArrayBuffer());
            let collection = collectionBuffer.toString('utf8');
            let markSheet = JSON.parse(markSheetBuffer.toString('utf8'));
            let i = 0;
            let markData = {
                USN: '',
                name: '',
                programmeName : markSheet.programmeName,
                department : markSheet.department,
                markDetails : {},
            }
            markData.markDetails[markSheet.semester] = {
                academicYear: markSheet.academicYear,
                semesterMarks: []
            };
            if(markSheet.type === 'Regular'){
                while(i<markSheet.studentMarks.length){
                    let element = markSheet.studentMarks[i];
                    // console.log(element.id.toString());
                    let studentDetailsAsBytes = await ctx.stub.getPrivateData(collection, element.id.toString());
                    if(!studentDetailsAsBytes || studentDetailsAsBytes.length === 0){
                        // console.log("no student exist in privatedata");
                        markData.USN = element.id.toString();
                        markData.name = element.name;
                        markData.markDetails[markSheet.semester].semesterMarks = element.marks;
                        markData.markDetails[markSheet.semester]["SGPA"] = element["SGPA"];
                        markData.markDetails[markSheet.semester].totalCredits = element.totalCredits;
                        markData.markDetails[markSheet.semester].totalCreditPoint = element.totalCreditPoint;
                        // console.log(markData);
                    }
                    else{
                        // console.log("Student exist in privatedata");
                        let studentDetails = JSON.parse(studentDetailsAsBytes.toString());
                        // console.log(studentDetails);
                        studentDetails.markDetails[markSheet.semester] = markData.markDetails[markSheet.semester];
                        studentDetails.markDetails[markSheet.semester].semesterMarks = element.marks;
                        markData.markDetails[markSheet.semester]["SGPA"] = element["SGPA"];
                        markData.markDetails[markSheet.semester].totalCredits = element.totalCredits;
                        markData.markDetails[markSheet.semester].totalCreditPoint = element.totalCreditPoint;
                        console.log(studentDetails);
                        markData = studentDetails;
                    }
                    await ctx.stub.putPrivateData(collection, markData.USN, Buffer.from(JSON.stringify(markData)));
                    i++;
                }
            }
            else{
                    throw new Error(`Invalid marksheet type ${markSheet.type}. Allowed types are ${type}.`)
            }
            console.log("The semester marks for all students have been updated.");
            return(JSON.stringify({response:"The semester marks for all students have been updated.!!!"}));
        } catch (error) {
            throw new Error(`Semester marks is not updated, this is the error faced in updating: ${error}`);
        }
    }

    async viewSemesterMarks(ctx, collection, id, semester) {
        try {
            const studentDetailsAsBytes = await ctx.stub.getPrivateData(collection, id);
            if (!studentDetailsAsBytes || studentDetailsAsBytes.length === 0) {
                throw new Error(`Student with USN ${id} does not exist`);
            }
            else{
                let studentDetails = JSON.parse(studentDetailsAsBytes.toString());
                console.log(studentDetails);
                let semesterMarks = {
                    USN: studentDetails.USN,
                    name: studentDetails.name,
                    department: studentDetails.department,
                    programmeName: studentDetails.programmeName,
                    semesterMark: studentDetails.markDetails[semester]
                }
                console.log(semesterMarks);
                return JSON.stringify(semesterMarks);
            }
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

    async viewAllSemesterMarks(ctx, collection, id) {
        try {
            const studentDetailsAsBytes = await ctx.stub.getPrivateData(collection, id);
            if (!studentDetailsAsBytes || studentDetailsAsBytes.length === 0) {
                throw new Error(`Student with USN ${id} does not exist`);
            }
            else{
                let studentDetails = JSON.parse(studentDetailsAsBytes.toString());
                return JSON.stringify(studentDetails);
            }
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

    async createCertificate(
        ctx,
        id,
        USN,
        name,
        complementaryCourse,
        type
    ) {
        let certificate = {
            id,
            USN,
            name,
            degree: '',
            mainCourse: '',
            grade: '',
            complementaryCourse,
            yearofReceival: new Date().getFullYear(),
            provider: "Kerala Kalamandalam",
            status: "Enabled",
            type
        };
        console.info(certificate);
        try {
            let finalGradeCard = await this.generateFinalGradeCard(ctx,'collectionMarkPrivateDetails',certificate.USN);
            let finalGradeCardJson = JSON.parse(finalGradeCard);
            certificate.grade = finalGradeCardJson.letterGrade;
            certificate.degree = finalGradeCardJson.programmeName;
            certificate.mainCourse = finalGradeCardJson.department;
            console.log(certificate);
            await ctx.stub.putState(
                certificate.id,
                Buffer.from(JSON.stringify(certificate))
            );
            console.log("The certificate is created");
            return(JSON.stringify({response:"The certificate is created successfully!!!"}));
        } catch (error) {
            throw new Error(
                "Certificate is not created this the error faced in creating: " +
                    error
            );
        }
    }

    async generateFinalGradeCard(ctx, collection, id) {
        try {
            console.log(id,collection);
            const studentDetailsAsBytes = await ctx.stub.getPrivateData(collection, id);
            if (!studentDetailsAsBytes || studentDetailsAsBytes.length === 0) {
                throw new Error(`Student with USN ${id} does not exist`);
            }
            else{
                let studentDetails = JSON.parse(studentDetailsAsBytes.toString());
                console.log(Object.keys(studentDetails.markDetails).length);
                // if(studentDetails.markDetails.length === 6){
                //     let finalGradeCard = {
                //         "CGPA": '',
                //         "letterGrade": '',
                //         "totalCredits": '',
                //         "totalPoints": ''
                //     }
                // }
                // else {
                //     throw new Error(`Student with USN ${id} has not finished all semester`);
                // }
                let finalGradeCard = {
                    "USN": studentDetails["USN"],
                    "name": studentDetails.name,
                    "department": studentDetails.department,
                    "programmeName": studentDetails.programmeName,
                    "CGPA": '',
                    "percentage": '',
                    "letterGrade": '',
                    "totalCredits": '',
                    "totalPoints": '',
                    "type": 'finalGradeCard'
                }
                let CGPA = 0;
                let totalCreditPoint=0;
                let totalCredits=0;
                Object.values(studentDetails.markDetails).forEach(element => {
                    totalCredits+=element.totalCredits;
                    totalCreditPoint+=element.totalCreditPoint;
                });
                CGPA = totalCreditPoint/totalCredits;
                console.log(CGPA,totalCreditPoint,totalCredits);
                finalGradeCard["CGPA"] = CGPA.toString();
                finalGradeCard.totalPoints = totalCreditPoint.toString();
                finalGradeCard.totalCredits = totalCredits.toString();
                let letterGrade = await this.findLetterGrade(CGPA);
                finalGradeCard.letterGrade = letterGrade;
                finalGradeCard.percentage = (CGPA*25).toString();
                console.log(finalGradeCard);
                await ctx.stub.putState(
                    finalGradeCard.USN,
                    Buffer.from(JSON.stringify(finalGradeCard))
                );
                return JSON.stringify(finalGradeCard);
            }
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

    async viewFinalGradeCard(ctx, id) {
        try {
            const finalGradeCardAsBytes = await ctx.stub.getState(id); // get the car from chaincode state
            if (!finalGradeCardAsBytes || finalGradeCardAsBytes.length === 0) {
                throw new Error(`${id} does not have final grade card generated as well as the certificate`);
            }
            else{
                let studentfinalGradeCard = JSON.parse(finalGradeCardAsBytes.toString());
                return JSON.stringify(studentfinalGradeCard);
            }
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

    async viewCertificate(ctx, querystring) {
        try {
            const resultIterator = await ctx.stub.getQueryResult(querystring);
            const certificates = [];
            while(true) {
                let res = await resultIterator.next();
                if(res.value && res.value.toString()) {
                    let certificate = {};
                    certificate.Key = res.value.Key;
                    certificate.Record = JSON.parse(res.value.value.toString("utf8"));
                    certificates.push(certificate);
                }
                if (res.done) {
                    await resultIterator.close();
                    return certificates;
                }
            }
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

    async revokeCertificate(ctx, id) {
        try {
            const certificateAsBytes = await ctx.stub.getState(id); // get the car from chaincode state
            if (!certificateAsBytes || certificateAsBytes.length === 0) {
                throw new Error(`${id} does not exist`);
            }
            console.log(certificateAsBytes.toString());
            let certificate = JSON.parse(certificateAsBytes.toString());
            certificate.status = "Disabled";
            try {
                await ctx.stub.putState(
                    certificate.id,
                    Buffer.from(JSON.stringify(certificate))
                );
                console.log("The certificate is updated");
                return(JSON.stringify({response:"The certificate is revoked successfully!!!"}));
            } catch (error) {
                throw new Error(
                    "certifiate is not revoked this the error faced in creating: " +
                        error
                );
            }
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

    async verifyCertificate(ctx, id) {
        try {
            const certificateAsBytes = await ctx.stub.getState(id); // get the car from chaincode state
            if (!certificateAsBytes || certificateAsBytes.length === 0) {
                throw new Error(`${id} does not exist`);
            }
            let certificate = JSON.parse(certificateAsBytes.toString());
            if(certificate.status === "Disabled")
                return (JSON.stringify({resposne: "The certificate is not valid"}));
            console.log(certificateAsBytes.toString());
            return certificateAsBytes.toString();
        } catch (error) {
            throw new Error(`Some error has occured ${error}`);
        }
    }

}

module.exports = Certificate;
