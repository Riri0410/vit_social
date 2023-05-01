import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vit_social/models/user.dart' as model;
import 'package:vit_social/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentuser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentuser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String name,
    required String username,
    required String password,
    required String email,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "An Error Occured!";
    try {
      if (email.isNotEmpty ||
          name.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          name: name,
          following: [],
          followers: [],
          photoUrl: photoUrl,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "Account Successfully Created!";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "Invalid Email";
      } else if (err.code == "weak-password") {
        res = "Password less than 6 characters";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Successfully Logged In!";
      } else {
        res = "Please fill all the fields";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "Invalid Email";
      } else if (err.code == "wrong-password") {
        res = "Invalid Password!";
      } else if (err.code == "user-not-found") {
        res = "User Not Found, Try Signing Up!";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
