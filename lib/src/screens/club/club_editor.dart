import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:events_app/src/models/club.dart';
import 'package:events_app/src/services/storage.dart';
import 'package:events_app/src/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// [ClubEditor] class is used to either create a new Club or edit an existing one:
//  - Create mode:  only pass an empty instance of [Club] class ( Club() ) for the event attribut
//  - Edit mode: pass the instance of Club to "club" attribut and set "editModeActive" to true
class ClubEditor extends StatefulWidget {

  final Club club;
  final bool editModeActive;
  ClubEditor({this.club, this.editModeActive});

  @override
  _ClubEditorState createState() => _ClubEditorState();
}

class _ClubEditorState extends State<ClubEditor> {

  // create a map with all event attributs non initialized [null] to use as a container 
  // for the different form-text-fields in the page 
  Map<String, String> clubData = Club().toMap();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Image file returned by image picker (can null initially)
  dynamic imageFile;
  
  // image from imageFile (can null initially), it can contain either:
  //   - Image.file(...) if user picks an image from his phone gallery
  //   - Image.network(...) if user is editing an existing event and didn't change the Club logo yet
  //   - an Icon(Icons.image) if no image is selected
  dynamic image;

  // Display a bottom sheet with a circular progress indicator while the club details 
  // and image are being uploaded to the database
  void showUploadProgressIndicator() {
    showModalBottomSheet(context: context, isDismissible: false, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Please wait while we upload your event"),
            SizedBox(height: 20.0),
            CircularProgressIndicator(),
          ],
        ),
      );
    });
  }

  // Upload club details and image to database:
  //  - if editing an existing club then use the [updateClub] method from [DatabaseServices] class
  //  - id creating an club use [addClub] method from [DatabaseServices] class because it generates a new unique id for the club
  void uploadClub() async {
    DocumentReference result = await DatabaseServices().addClub(Club.fromMap(clubData));
    await StorageServices().uploadclubLogo(imageFile, result.id);

    // first pop; to close for bottomsheet (upload progress indicator)
    Navigator.pop(context);
    // second pop; to exit event editor and get back to club screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The app bar contains the title of the page and 2 buttons; one to cancel and one to confirm and upload club
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Club Editor"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close), 
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 15.0),
          // confirm button
          IconButton(
            icon: Icon(Icons.done), 
            onPressed: () {
              // check if all inputs are valid, if so upload club
              if(_formKey.currentState.validate()) {
                if(imageFile != null) {
                  uploadClub();
                  showUploadProgressIndicator();
                } else {
                  final snackBar = SnackBar(backgroundColor: Colors.red, content: Text('Please add a logo to your club.', style: TextStyle(color: Colors.white, fontSize: 20.0)));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            }
          ),
        ],
      ),

      // body contains all the Form field to fill:
      // image (club logo), club name, club name alias, club description  
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                imagePicker(),
                
                // Club name form field
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Club Name:', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      TextFormField(
                        initialValue: clubData['name'],
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          hintText: 'name'
                        ),
                        validator: (val) => val.isEmpty? 'A club name is required': null,
                        onChanged: (val) {
                          setState(() {
                            clubData['name'] = val;
                          });
                        },
                      ),   
                    ],
                  ),
                ),

                // Club alias form field
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Club Alias:', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      TextFormField(
                        initialValue: clubData['alias'],
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          hintText: 'example: computer society => CS'
                        ),
                        validator: (val) => val.isEmpty? 'An alias required (it can be same as name)': null,
                        onChanged: (val) {
                          setState(() {
                            clubData['alias'] = val;
                          });
                        },
                      ),   
                    ],
                  ),
                ),

                // Club description form field
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description:', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0),
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: TextFormField(
                          initialValue: clubData['description'],
                          minLines: 1,
                          maxLines: 99,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            hintText: 'description',
                            border: InputBorder.none,
                          ),
                          validator: (val) => val.isEmpty? 'A description is required': null,
                          onChanged: (val) {
                          setState(() {
                            clubData['description'] = val;
                          });
                        },
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // image picked implementation
  Widget imagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 200.0,
          width: double.infinity,
          color: Colors.grey.shade300,
          child: image ?? Icon(Icons.image, size: 50.0),
        ),
        SizedBox(height: 10.0),
        OutlinedButton(
          child: Text('Browse'),
          onPressed: () async {
            final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
            if(pickedFile != null){
              setState(() {
                imageFile = File(pickedFile.path);
                image = Image.file(imageFile);
              });
            }
          },
        ),
      ],
    );
  } 
}