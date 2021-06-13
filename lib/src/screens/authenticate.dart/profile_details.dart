import 'package:events_app/src/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:events_app/src/services/auth.dart';
import 'package:events_app/src/services/database.dart';
import 'package:events_app/src/screens/loading.dart';
import 'package:events_app/src/models/user_model.dart';
import 'package:provider/provider.dart';


// when users want to create email they first have fill in their email and password on the registration screen,
// if those are valid, users are then forwarded to this screen where they should fill some other informations: first and last name and their university
class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {


  final _formKey = GlobalKey<FormState>();

  // instance of AuthService that have the methods necessary for user authentication; logging in, registration, logging out...
  final AuthService _auth = AuthService();

  // state objects
  bool _loading = false;
  String firstName = '';
  String lastName = '';
  String university = '';

  @override
  Widget build(BuildContext context) {
    
    // instance of UserModel which contains user credentials (except password) provided by a StreamProvider
    // this is used to display some user info on the drawer and can also be passed to the profile screen  
    final UserModel _user = Provider.of<UserModel>(context);

    // retrieve data forwarded by registration screen; email and password
    final Map userData = ModalRoute.of(context).settings.arguments;

    // unpack email and password 
    final _email = userData['email'];
    final _password = userData['password'];

    // the variable _loading indicates if the user filled credentials and pressed the finish registration button
    // if _loading is set to false then the build widget constructs and returns the profile details screen
    // else if _loading is set to true then the build method will return the -intuitively- a loading screen
    // if registration succeeds then forward uer to HomeScreen
    return _user == null? _loading? Loading(): Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // form field to get first name
            TextFormField(
              onChanged: (val) => firstName = val,
              decoration: InputDecoration(
                hintText: 'first name',
              ),

              validator: (val) {
                final pattern = r'^[A-Za-z]+$';
                final regExp = RegExp(pattern);

                if(val.isEmpty){
                  return "at least 1 character is required!";
                } else if(!regExp.hasMatch(val)){
                  return "only alphabetical characters are allowed!";
                } else {
                  return null;
                }
              }
            ),

            // form field to get last name
            TextFormField(
              onChanged: (val) => lastName = val,
              decoration: InputDecoration(
                hintText: 'last name',
              ),

              validator: (val) {
                final pattern = r'^[A-Za-z]+$';
                final regExp = RegExp(pattern);

                if(val.isEmpty){
                  return "at least 1 character is required!";
                } else if(!regExp.hasMatch(val)){
                  return "only alphabetical characters are allowed!";
                } else {
                  return null;
                }
              }
            ),

            // form field to get user university
            TextFormField(
              onChanged: (val) => university = val,
              decoration: InputDecoration(
                hintText: 'university',
              ),

              validator: (val) {
                final pattern = r'^[A-Za-z]+$';
                final regExp = RegExp(pattern);
                if(val.isEmpty){
                  return "at least 1 character is required!";
                } else if(!regExp.hasMatch(val)){
                  return "only alphabetical characters are allowed!";
                } else {
                  return null;
                }
              }
            ),
            
            // finish registration button
            ElevatedButton(
              onPressed: () async {
                setState(() => _loading = true);
                if(_formKey.currentState.validate()) {
                  dynamic result = await _auth.registerWithEmailAndPassword(_email, _password);
                  if(result == null) {
                    final snackBar = SnackBar(backgroundColor: Colors.red, content: Text('email already in use', style: TextStyle(color: Colors.white, fontSize: 20.0)));
                    setState(() => _loading = false);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    await DatabaseServices(id: result.uid).updateUserData(firstName, lastName, university);
                  }
                }
              },
              child: Text('finish registration'),
            ),

          ],
        ),
      ),
    ): HomeScreen();
  }
}