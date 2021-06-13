import 'package:flutter/material.dart';
import 'package:events_app/src/models/user_model.dart';
import 'package:events_app/src/screens/home/home_screen.dart';
import 'package:events_app/src/screens/authenticate.dart/login.dart';
import 'package:provider/provider.dart';

// Wrapper screen wraps the whole application and decides what screens to render
// as the authentication state changes
class Wrapper extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final UserModel user = Provider.of<UserModel>(context);

    return user == null 
      ? LogIn()
      : HomeScreen(user: user);
  }
}

