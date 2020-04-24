'use strict';

const {Parser} = require('json2csv');
const fs = require('fs');
const functions = require('firebase-functions');
const firestoreExport = require('node-firestore-import-export');
const serviceAccount = require("./credentials.json");
const admin = require('firebase-admin');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://nirushka-46e30.firebaseio.com"
});

const nodemailer = require('nodemailer');

// TODO: Configure the `gmail.email` and `gmail.password` Google Cloud environment variables.
const gmailEmail = functions.config().gmail.email;
// const gmailEmail = "";
const gmailPassword = functions.config().gmail.password;
// const gmailPassword = "";

const mailTransport = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: gmailEmail,
        pass: gmailPassword,
    },
});

const APP_NAME = 'Cloud Storage for Firebase quickstart';
exports.sendWelcomeEmail = functions.https.onRequest(async (req, res) => {
    const email = 'ronyehezkel90@gmail.com';
    const displayName = 'Ronchuk';
    getExcelFile().then(csvFile => {
        return sendMail(email, displayName, csvFile).catch(err => {
            console.log("error in sendMail" + err)
        });
    }).catch(err => {
        console.log("error in getExcelFile" + err);
        throw err;
    });
});

async function sendMail(email, displayName, csvFile) {
    const mailOptions = {
        from: `${APP_NAME} <noreply@firebase.com>`,
        to: email,
    };
    mailOptions.subject = `Welcome to ${APP_NAME}!`;
    mailOptions.text = `Hey ${displayName || ''}! Welcome to ${APP_NAME}. I hope you will enjoy our service.`;

    mailOptions.attachments = [
        {
            name: 'file.csv',
            path: csvFile
        }
    ];
    await mailTransport.sendMail(mailOptions);
    console.log('New welcome email sent to:', email);
    return null;
}

async function getExcelFile() {
    let recordsJson = [];
    let db = admin.firestore();
    await db.settings({timestampsInSnapshots: true});

    await db.collection('records').get()
        .then(querySnapshot => {
            querySnapshot.forEach(doc => {
                recordsJson.push(doc.data());
            });
            let fields = ["entrepreneur", "project", "dealDate", "apartmentNumber", "buyers", "price", "legalPayment", "isMishtakenPrice"];
            const parser = new Parser({
                fields,
                unwind: fields
            });

            const csv = parser.parse(recordsJson);
            const filename = '/tmp/file.csv';

            fs.writeFile(filename, csv, {flag: 'w'}, function (err) {
                if (err) throw err;
                console.log('file saved');
            });
            return filename;
        })
}
