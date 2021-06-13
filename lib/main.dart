import 'package:events_app/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:events_app/src/models/user_model.dart';
import 'package:events_app/src/screens/authenticate.dart/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:events_app/src/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:events_app/src/screens/authenticate.dart/profile_details.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    print('error in initilization');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/profile details': (context) => ProfileDetails(),
          '/sign up': (context) => Register(),
        },
      ),
    );
  }
}



// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: ClubEditor(club: Club()));
//   }
// }


