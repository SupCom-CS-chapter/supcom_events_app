import 'package:events_app/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:events_app/src/screens/loading.dart';


class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    // the variable _loading indicates if the user filled credentials and pressed the log in button
    // if _loading is set to false then the build widget constructs and returns the log in screen
    // else if _loading is set to true then the build method will return the -intuitively- a loading screen
    // if log in succeeds forward user to HomeScreen
    return _loading ? Loading(): Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            // create the decorations on the top of the login screen
            Container(
              height: 420,
              child: Stack(
                children: <Widget>[

                  // place blue background on top of the login screen
                  Positioned(
                    right: -25,
                    height: 440,
                    width: width+75,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login_bg.png'),
                          fit: BoxFit.fill,
                        )
                      ),
                    ),
                  ),

                  // place calender vector art
                  Positioned(
                    top: 230,
                    left: width/4,
                    width: width/2,
                    height: width/2,
                    child: Image.asset('assets/images/event_vector_art.png'),
                  ),

                  // place  CS chapter logo
                  Positioned(
                    top: 60,
                    right: 10,
                    height: 400,
                    width: width - 250,
                    child: Container(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset('assets/images/cs.png'),
                      ),
                    ),
                  ),

                  // place application name
                  Positioned(
                    top: 170,
                    height: 60,
                    width: width,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/app_title.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // create  login form
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text("Login", style: TextStyle(color: Color.fromRGBO(49, 39, 79, 1), fontWeight: FontWeight.bold, fontSize: 30),),
                  ),
                  SizedBox(height: 30,),

                  // container wrapping email and password form fields
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(140, 184, 184, 184),
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        )
                      ]
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[

                          // create and decorate email form field
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: Colors.grey.shade200,
                              ))
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofocus: false,
                              autocorrect: false,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "E-mail",
                                //hintStyle: TextStyle(color: Colors.grey),
                                icon: Icon(Icons.mail, color: Colors.grey, size: 15),
                              ),

                              // validate email format
                              validator: (value) {
                                final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                                final regExp = RegExp(pattern);

                                if (value.isEmpty) {
                                  return 'Enter an email';
                                } else if (!regExp.hasMatch(value)) {
                                  return 'Enter a valid email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),

                          //create and decorate password form field
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              controller: _passwordController,
                              autofocus: false,
                              autocorrect: false,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              //password invisible
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                icon: Icon(Icons.lock, color: Colors.grey, size: 15),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText ? Icons.visibility_off: Icons.visibility, color: Colors.grey, size: 20),
                                  //toggle between visible and invisible password modes
                                  onPressed: (){
                                    setState((){
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // login button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // check if all inputs are valid using the _formKey passed to the [Form] widget on top
                        final isValid = _formKey.currentState.validate();

                        //if input is valid then autheticate with firebase
                        if(isValid){

                          // reder laoding screen
                          setState(() => _loading = true);
    
                          dynamic result = await _auth.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                          // if login fails, show an snackBar containing the error and fallback to login screen to retry
                          // the previous inputs in email and password textfield are also cleared for convenience
                          if(result == null) {
                            final snackBar = SnackBar(backgroundColor: Colors.red, content: Text('Wrong Credentials! try again.', style: TextStyle(color: Colors.white, fontSize: 20.0)));
                            _emailController.clear();
                            _passwordController.clear();
                            setState(() => _loading = false);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }
                      },

                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold,)),
                      ),

                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 159, 255)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                      ),

                    ),
                  ),

                  SizedBox(height: 5),

                  // password recovery button
                  Center(
                    child: TextButton(
                      onPressed: (){},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 159, 255),
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // registration buttom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account yet? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          FocusScope.of(context).unfocus();
                          Navigator.pushNamed(context, '/sign up');
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color.fromARGB(255, 20, 159, 255),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}