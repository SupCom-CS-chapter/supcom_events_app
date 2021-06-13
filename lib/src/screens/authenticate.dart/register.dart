import 'package:flutter/material.dart';


// Registration screen
class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              // create decoration at the top of the screen
              Container(
                height: 330,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      width: width,
                      height: 400,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/register_bg.png"),
                            fit: BoxFit.fill
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 20,
                      width: width-40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "We are thrilled to have you among us. Create an account to get started.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // create e-mail form field
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 20, 50, 0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText : "E-mail",
                  ),

                  onChanged: (val) => _email = val,

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

              // create password form field
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 20, 50, 0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText : "Password",
                  ),
                  obscureText: true,
                  onChanged: (val) => _password = val,
                  validator: (value) {
                    if(value.length < 8){
                      return "at least 8 caracters are required";
                    } else {
                      return null;
                    }
                  }
                ),
              ),

              // create password confirmation form field
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 20, 50, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText : "Confirm Password",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if(value != _password) {
                      return "password does not match";
                    } else {
                      return null;
                    }
                  }
                ),
              ),

              // create registration button
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 159, 255)),
                          //shadowColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 159, 255)),
                          //elevation: MaterialStateProperty.all<double>(5),
                          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: (){

                    if(_formKey.currentState.validate()){
                      Navigator.pushReplacementNamed(context, '/profile details', arguments: {'email': _email, 'password': _password});
                    }
                    //createAlertDialog();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // create alert dialog asking for email verification
  Future<String> createAlertDialog(){
    final pinController = TextEditingController();
    return showDialog(context: context, builder: (context){
      return AlertDialog(

        title: Text("verify your e-mail address"),
        content: TextFormField(
          controller: pinController,
          keyboardType: TextInputType.number,
          validator: (value){
            if(value.length != 4){
              return "enter 4 digits";
            } else {
              return null;
            }
          }
        ),
        actions: [
          OutlinedButton(
            child: Text("Submit"),
            onPressed: (){
              //authenticate email address
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

}