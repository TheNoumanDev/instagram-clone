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

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentID = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentID)
            .set(
          {
            'profilePic': profilePic,
            'name': name,
            'uid': uid,
            'text': text,
            'commentId': commentID,
            'datePublished': DateTime.now(),
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // delete post
  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc(postID).delete();
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }
}
