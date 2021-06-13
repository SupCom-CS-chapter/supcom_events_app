import 'package:flutter/Material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//this page currenly only serves an asthetic purpose.
//in the future it will serve as a buffering screen for clubs and events to load from database.

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 20, 159, 255),
      body: Center(
        child: SpinKitThreeBounce(
          color: Colors.white,
          size:80.0,
        ),
      ),
    );
  }
}