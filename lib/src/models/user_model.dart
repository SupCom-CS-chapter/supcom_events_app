import 'package:meta/meta.dart';

class UserModel {

  final String uid;
  final String email;
  final String photoURL;
  final String displayName;
  
  UserModel({@required this.uid, this.email, this.photoURL, this.displayName});

}

class UserData {

  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String university;
  //final String picURL;

  UserData({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.university,
    //this.picURL,
  });

}