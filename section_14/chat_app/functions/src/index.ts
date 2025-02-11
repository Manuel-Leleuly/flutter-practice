import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
exports.myFunction = functions.firestore.onDocumentCreated(
  "chat/{messageId}",
  (snapshot) => {
    // Return this function's promise, so this ensures the firebase function
    // will keep running, until the notification is scheduled.
    return admin.messaging().send({
      // Sending a notification message.
      notification: {
        title: snapshot!.data!.data()["username"] ?? "username",
        body: snapshot!.data!.data()["text"] ?? "text",
      },
      data: {
        // Data payload to be sent to the device.
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
      topic: "chat",
    });
  }
);
