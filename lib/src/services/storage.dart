import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageServices {

  // reference
  FirebaseStorage _storage = FirebaseStorage.instance;

  // upload user profile picture
  Future<String> uploadUserProfileImage(File image, String uid) async {
    Reference storageRef = _storage.ref().child("user/profile/$uid");
    try {
      TaskSnapshot uploadTask = await storageRef.putFile(image);
      String downloadURL = await uploadTask.ref.getDownloadURL();
      return downloadURL;
    } catch(e) {
      print('upload failed');
      return null;
    }
  }

  // get download link for user profile picture from firabase storage
  Future<String> getUserProfileImage(String uid) async {
    return await _storage.ref().child("users/profiles/$uid").getDownloadURL();
  }

  // upload event poster
  Future<String> uploadEventPoster(File image, String eventID) async {
    Reference storageRef = _storage.ref().child("events/posters/$eventID");
    try {
      TaskSnapshot uploadTask = await storageRef.putFile(image);
      String downloadURL = await uploadTask.ref.getDownloadURL();
      return downloadURL;
    } catch(e) {
      print('upload failed');
      return null;
    }
  }


  // get download link event poster from firabase storage
  Future<String> getEventPoster(String eventID) async {
    return await _storage.ref().child("events/posters/$eventID").getDownloadURL();
  }


  // upload club logo
  Future<String> uploadclubLogo(File image, String clubID) async {
    Reference storageRef = _storage.ref().child("clubs/logos/$clubID");
    try {
      TaskSnapshot uploadTask = await storageRef.putFile(image);
      String downloadURL = await uploadTask.ref.getDownloadURL();
      return downloadURL;
    } catch(e) {
      print('upload failed');
      return null;
    }
  }

  // get download link for club logo from firabase storage
  Future<String> getClubLogo(String clubID) async {
    return await _storage.ref().child("clubs/logos/$clubID").getDownloadURL();
  }

  
}
