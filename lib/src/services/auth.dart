import 'package:firebase_auth/firebase_auth.dart';
import 'package:events_app/src/models/user_model.dart';

// Authentication service class:
// provides log in, registration, logging out services
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel get currentUser {
    return _userFromFireBaseUser(_auth.currentUser);
  }

  // firebase User object has too many unneeded properties,
  // this will create a custom user object with only the necessary properties
  UserModel _userFromFireBaseUser(User user) {
    return user != null ? UserModel(uid: user.uid, email: user.email): null;
  }

  // the stream allows firebase to inform app instances of any change
  // in user authentication state. this will be used to tell the app what screen to render:
  //    - if the stream returns null then render authentication screen
  //    - if the stream returns a non-null object then the user have already logged in, thus render the home screen
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromFireBaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign up with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      //await DatabaseServices().updateUserData('first name', 'last name', 'university');
      return _userFromFireBaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}
