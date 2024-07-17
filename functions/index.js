/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.saveLocation = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    return res.status(405).send('Method Not Allowed');
  }

  const location = req.body.location;

  if (!location) {
    return res.status(400).send('Bad Request: Missing location');
  }

  try {
    const writeResult = await admin.firestore().collection('locations').add({ location: location });
    return res.status(201).send(`Location saved with ID: ${writeResult.id}`);
  } catch (error) {
    console.error('Error saving location: ', error);
    return res.status(500).send('Internal Server Error');
  }
});


