import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Below funtion is used to upload media to Firebase storage in respective folder using childName.
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // Below Line will create a referance to the folder where we want to upload the file using the current user UID.
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    // putData is used to put Uint8List file and will return a Uploadtask FIle.
    UploadTask uploadTask = ref.putData(file);

    // When it will be uploaded, then it will return a snap that we can use to get the download URL to
    // of the file uploaded to use in future so that we can show it using Network Image widget.
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
