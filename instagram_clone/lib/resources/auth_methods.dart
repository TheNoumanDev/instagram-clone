// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/utils/utils.dart';

class AuthMethds {
  // Firebase Variables.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // We need to signup user, will take necessary parameters from user.
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
    required BuildContext context,
  }) async {
    String res = "Some Error occoured";

    try {
      // Just keeping a check that they are not Empty.
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // User will be registered using this method here and its detail will be in cre.
        UserCredential cre = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Now we will save the photo of the user to storage using below functiona dn will get the URL of
        // Picture so that we can also store it in Users Profile propertities.
        String photoURL = await StorageMethods()
            .uploadImageToStorage('ProfilePictures', file, false);

        // Add user details to database!
        await _firestore.collection('users').doc(cre.user!.uid).set({
          'username': username,
          'uid': cre.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photourl': photoURL,
        });

        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        res = "The password provided is too weak.";
        // ShowDialogGeneric(context, "The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        res = "The account already exists for that email.";
        // ShowDialogGeneric(
        //     context, "The account already exists for that email.");
      } else if (e.code == "invalid-email") {
        res = "The email is invalid.";
        //ShowDialogGeneric(context, "The email is invalid.");
      } else {
        res = "Something went wrong.";
        //ShowDialogGeneric(context, "Something went wrong.");
      }
    } catch (err) {
      //ShowDialogGeneric(context, err.toString());
      res = err.toString();
    }
    return res;
  }

  Future<String> signIpUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some Error occoured";

    try {
      // Just keeping a check that they are not Empty.
      if (email.isNotEmpty || password.isNotEmpty) {
        print(email + password);
        // User will be registered using this method here and its detail will be in cre.
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = 'success';
      }
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == "weak-password") {
      //     res = "The password provided is too weak.";
      //     // ShowDialogGeneric(context, "The password provided is too weak.");
      //   } else if (e.code == "email-already-in-use") {
      //     res = "The account already exists for that email.";
      //     // ShowDialogGeneric(
      //     //     context, "The account already exists for that email.");
      //   } else if (e.code == "invalid-email") {
      //     res = "The email is invalid.";
      //     //ShowDialogGeneric(context, "The email is invalid.");
      //   } else {
      //     res = "Something went wrong.";
      //     //ShowDialogGeneric(context, "Something went wrong.");
      //   }
    } catch (err) {
      //ShowDialogGeneric(context, err.toString());
      res = err.toString();
    }
    return res;
  }
}
