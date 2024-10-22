import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadResult {
  final Reference storageReference;
  final String fileExtension;

  UploadResult(this.storageReference, this.fileExtension);
}

Future<bool> uploadMaterialProfile(
  String uid,
  Uint8List selectedImage,
  String filename,
  String classno,
  Function(int progress)? onProgress,
) async {
  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child("classesData/$uid/materials/$classno/$filename");

  UploadTask uploadTask = storageReference.putData(selectedImage);

  Completer<bool> completer = Completer<bool>();

  uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
    double progress = snapshot.bytesTransferred / snapshot.totalBytes;
    int percentage = (progress * 100).toInt();
    onProgress?.call(percentage);
  });

  await uploadTask.whenComplete(() async {
    if (uploadTask.snapshot.state == TaskState.success) {
      final extension = filename.split('.').last.toLowerCase();
      String finalextensions;
      List<String> imageExtensions = [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'bmp',
        'webp'
      ];
      if (imageExtensions.contains(extension)) {
        finalextensions = "Image";
      } else {
        finalextensions = extension;
      }
      bool savedToFirestore = await saveToFirestore(
          uid, classno, storageReference, finalextensions);
      completer.complete(savedToFirestore);
    } else {
      completer.complete(false);
    }
  });

  return completer.future;
}

Future<bool> saveToFirestore(
  String uid,
  String classno,
  Reference storageReference,
  String extension,
) async {
  try {
    await FirebaseFirestore.instance.collection('classMaterial').add({
      'classid': uid,
      'classno': classno,
      'reference': storageReference.fullPath,
      'extension': extension,
    });
    return true;
  } catch (e) {
    return false;
  }
}


Future<bool> uploadCerticate(
  String uid,
  Uint8List selectedImage,
  String filename,
  String classno,
  Function(int progress)? onProgress,
) async {
  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child("$uid/Certificates/$filename");

  UploadTask uploadTask = storageReference.putData(selectedImage);

  Completer<bool> completer = Completer<bool>();

  uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
    double progress = snapshot.bytesTransferred / snapshot.totalBytes;
    int percentage = (progress * 100).toInt();
    onProgress?.call(percentage);
  });

  await uploadTask.whenComplete(() async {
    if (uploadTask.snapshot.state == TaskState.success) {
      final extension = filename.split('.').last.toLowerCase();
      String finalextensions;
      List<String> imageExtensions = [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'bmp',
        'webp'
      ];
      if (imageExtensions.contains(extension)) {
        finalextensions = "Image";
      } else {
        finalextensions = extension;
      }
      bool savedToFirestore = await saveCertificate(
          uid, classno, storageReference, finalextensions);
      completer.complete(savedToFirestore);
    } else {
      completer.complete(false);
    }
  });

  return completer.future;
}

Future<bool> saveCertificate(
  String uid,
  String classno,
  Reference storageReference,
  String extension,
) async {
  try {
    await FirebaseFirestore.instance.collection('classMaterial').add({
      'classid': uid,
      'classno': classno,
      'reference': storageReference.fullPath,
      'extension': extension,
    });
    return true;
  } catch (e) {
    return false;
  }
}