import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firebaseAuth = FirebaseAuth.instance;
final _firebaseStorage = FirebaseStorage.instance;
final _firebaseFirestore = FirebaseFirestore.instance;

class AuthLogic {
  const AuthLogic();

  Future<(UserCredential?, FirebaseAuthException?)> submitAuth({
    required String email,
    required String password,
    required bool isLogin,
    required String username,
    File? imageFile,
  }) async {
    if (!isLogin && imageFile != null) {
      return registerUser(email, password, username, imageFile);
    }
    return loginUser(email, password);
  }

  Future<(UserCredential?, FirebaseAuthException?)> loginUser(
    String email,
    String password,
  ) async {
    try {
      final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (userCredentials, null);
    } on FirebaseAuthException catch (error) {
      return (null, error);
    }
  }

  Future<(UserCredential?, FirebaseAuthException?)> registerUser(
    String email,
    String password,
    String username,
    File imageFile,
  ) async {
    try {
      // create user
      final userCredentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // upload profile picture
      final storageRef = _firebaseStorage
          .ref()
          .child('user_images')
          .child('${userCredentials.user?.uid ?? 'user_image'}.jpg');
      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();
      await _firebaseFirestore
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': username,
        'email': email,
        'image_url': imageUrl,
      });

      return (userCredentials, null);
    } on FirebaseAuthException catch (error) {
      return (null, error);
    }
  }

  void signOutUser() {
    _firebaseAuth.signOut();
  }
}
