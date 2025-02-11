import 'package:chat_app/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final _firebaseFirestore = FirebaseFirestore.instance;
final _firebaseAuth = FirebaseAuth.instance;
final _firebaseMessaging = FirebaseMessaging.instance;

class MessageLogic {
  const MessageLogic();

  Future<void> initializedPushNotification() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print(token);

    await _firebaseMessaging.subscribeToTopic('chat');
  }

  Future<void> saveMessageToFirestore(String message) async {
    final user = _firebaseAuth.currentUser!;
    final userData =
        await _firebaseFirestore.collection('users').doc(user.uid).get();

    final userDataMap = userData.data()!;

    await _firebaseFirestore.collection('chat').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userDataMap['username'],
      'userImage': userDataMap['image_url'],
    });
  }

  FirestoreSnapshotStream getMessagesFromFirestore() {
    return _firebaseFirestore
        .collection('chat')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
