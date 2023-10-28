import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post

  Future<String> uploadPost(String des, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error Occured";
    try {
      // Store it in storage
      String postURL =
          await StorageMethods().uploadImageToStorage("Posts", file, true);
      String postID = Uuid().v1();

      Post post = Post(
        description: des,
        uid: uid,
        postUrl: postURL,
        username: username,
        postID: postID,
        datePublished: DateTime.now(),
        profImage: profImage,
        likes: [],
      );

      // upload it to firestore
      _firestore.collection("posts").doc(postID).set(post.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
