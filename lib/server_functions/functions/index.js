/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const { onRequest } = require("firebase-functions/v2/https");
// const {onDocumentWritten}= require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const functions = require("firebase-functions");
admin.initializeApp();

const Twilio = require("twilio");
// const { user } = require("firebase-functions/v1/auth");
const accountSid = functions.config().twilio.sid;
const authToken = functions.config().twilio.token;

const twilioClient = new Twilio(accountSid, authToken);
const twilioNumber = "+18663058928";
const phoneVerificationValues = {};
const allowTextMessages = false; // TODO: Change to true to allow text messages

exports.writeMessage = functions.https.onCall(async (data, context) => {
  const message = data.text;
  logger.log("===== : GOT MESSAGE" + message);
  return "Message gotten " + message;
});
exports.callCreateAccountAttempt = functions.https
    .onCall(async (data, context) => {
      // TODO: Check for phone number already in use
      const username = data.username;
      const phonenumber = data.phonenumber;
      const password = data.password;
      const notifID = data.notifID;

      // verify user/pass/phone
      if (username.length < 5) {
        return {error: "Username must be least 5 characters"};
      }
      if (password.length < 5) {
        return {error: "Password must be least 5 characters"};
      }
      if (!validE164(phonenumber)) {
        return {error: "Invalid phone number"};
      }
      // test if user already exists
      return await usernameExists(username).then((exists) => {
        if (exists) return {error: "Username already in use"};
        // generate random key
        let key;
        do {
          key = randomPhoneKey();
        } while (phoneVerificationValues[key] != undefined);
        // save verify to db
        admin.firestore()
            .collection("users")
            .doc(username).set({
              username: username,
              password: password,
              phonenumber: phonenumber,
              notifID: notifID,
              verificationCode: key,
              verified: false,
              stores: [],
            });
        // send verification code
        if (allowTextMessages) {
          const textMessage = {
            body: "Managment Verification code: " + key,
            to: phonenumber,
            from: twilioNumber,
          };
          twilioClient.messages.create(textMessage)
              .then(async (message) => {
                console.log(message.sid, "Success");
              });
        }
        // return success status
        return {error: ""};
      });
      // logger.log("===== : GOT MESSAGE" + message);
      // return "Message gotten " + message;
    });
exports.callSendNewCode = functions.https
    .onCall(async (data, context) => {
      const username = data.username;
      const phonenumber = data.phonenumber;

      // verify user/pass/phone
      if (!validE164(phonenumber)) {
        return {error: "Invalid phone number"};
      }
      // test if user already exists
      return await usernameExists(username).then((exists) => {
        let key;
        do {
          key = randomPhoneKey();
        } while (phoneVerificationValues[key] != undefined);
        // save verify to db
        admin.firestore()
            .collection("users")
            .doc(username).update({
              phonenumber: phonenumber,
              verificationCode: key,
              verified: false,
            });
        // send verification code
        if (allowTextMessages) {
          const textMessage = {
            body: "Managment Verification code: " + key,
            to: phonenumber,
            from: twilioNumber,
          };
          twilioClient.messages.create(textMessage)
              .then(async (message) => {
                console.log(message.sid, "Success");
              });
        }
        // return success status
        return {error: ""};
      });
    });

exports.callCancelAccountCreate = functions.https
    .onCall(async (data, context) => {
      const username = data.username;
      const id = data.notifID;
      // verify user/pass/phone
      const docRef = admin.firestore()
          .collection("users")
          .doc(username);
      return await docRef.get().then((doc) => {
        if (!doc.exists) return false;
        const token = doc.data().notifID;
        const isVerif = doc.data().verified;
        if (token !== id) return false;
        if (isVerif) return false;
        docRef.delete();
        return true;
      });
    });

exports.callVerifyPhoneNumberCode = functions.https
    .onCall(async (data, context) => {
      const username = data.username;
      const code = data.code;
      // compare code
      const docRef = admin.firestore()
          .collection("users")
          .doc(username);
      return await docRef.get()
          .then((doc) => {
            if (!doc.exists) return false;
            const myCode = doc.data().verificationCode;
            const token = doc.data().notifID;

            if (myCode == undefined) return false;
            if (myCode !== code) return false;
            // code IS valid
            docRef.update({"verified": true});
            // send notification
            const payload = {
              token: token,
              notification: {
                title: "Account Verified",
                body: "User account " + username + " has been verified",
              },
            };
            admin.messaging().send(payload);
            return true;
          });
    });


/**
 * Confirms that a phone number is a valid E164 number
 * @param {string} num - The phone number as a string
 * @return {bool} if the phone number is a valid E164
 */
function validE164(num) {
  return /^\+[1-9]\d{10,14}$/.test(num);
}
/**
 * Generates a random key for phone verifcation
 * @return {bool} random key
 */
function randomPhoneKey() {
  let key = "";
  const characters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  const charactersLength = characters.length;
  for (let i = 0; i < 6; i++) {
    key += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return key;
}
/**
 * Tests if a username exists
 * @param {string} username - Username to test against
 * @return {bool} does username exist
 */
function usernameExists(username) {
  return admin.firestore()
      .collection("users")
      .doc(username)
      .get()
      .then((doc) => {
        return doc.exists;
      });
}

exports.textStatus = functions.firestore
    .document("smsVerify/{smsKey}").onCreate(async (change, context) => {
      const data = change.data();
      const phoneNumber = data.phonenumber;
      if (!validE164(phoneNumber)) {
        throw new Error("Number must be E164 format!");
      }

      const textMessage = {
        body: "Managment Verification code: ABCDEF",
        to: phoneNumber,
        from: twilioNumber,
      };
      twilioClient.messages.create(textMessage)
          .then(async (message) => {
            console.log(message.sid, "Success");
          });
    });


exports.messageTest = functions.firestore
    .document("messages/{messageID}").onCreate(async (change, context) => {
      const data = change.data();
      const from = data.name;
      const to = data.to;
      const message = data.message;

      // get recipients device token
      await admin.firestore()
          .collection("users")
          .doc(to)
          .get()
          .then(async (doc) => {
            const token = doc.data().notifID;
            const payload = {
              token: token,
              notification: {
                title: "Message from " + from,
                body: message,
              },
              // data: {
              //   body: message,
              // },
            };
            admin.messaging().send(payload).then((response) => {
              logger.log("RESPONSE ===> " + response);
              return {success: true};
            }).catch((error) => {
              return {error: error.code};
            });
            admin.firestore().collection("reply").doc().set({
              "message": message,
              "sender": from,
              "to": to,
              "token": token,
            });
          });
      // logger.info("======>" + deviceToken);
      // send
    });
// exports.messageTest = functions.firestore
//     .document("reply/{messageID}").onWrite(async (change, context) => {
//       await admin.firestore().collection("messages").doc().set({
//         "content": "Oh hey gurl",
//         "sender": "Server",
//       });
//     });
