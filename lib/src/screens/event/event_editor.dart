import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app/src/models/event.dart';
import 'package:events_app/src/services/database.dart';
import 'package:events_app/src/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:events_app/src/utils/utils.dart';
import 'dart:io';


// [EventEditor] class used to either create a new event or edit an existing one:
//  - Create mode:  only pass an empty instance of [Event] class ( Event() ) for the event attribut
//  - Edit mode: pass the instance of Event to "event" attribut and set "editModeActive" to true
class EventEditor extends StatefulWidget {
  
  final Event event;
  final bool editModeActive;

  EventEditor({@required this.event, this.editModeActive: false});

  @override
  _EventEditorState createState() => _EventEditorState();
}

class _EventEditorState extends State<EventEditor> {

  final _formKey = GlobalKey<FormState>();

  // create a map with all event attributs non initialized [null] to use as a container 
  // for the different form-text-fields in the page 
  Map eventData = Event().toMap();

  @override
  void initState(){
    super.initState();
    eventData = widget.event.toMap();
    if(widget.editModeActive) {
      image = Image.network(widget.event.poster);
    }
  }

  // Image file returned by image picker (can null initially)
  dynamic imageFile;

  // image from imageFile (can null initially), it can contain either:
  //   - Image.file(...) if user picks an image from his phone gallery
  //   - Image.network(...) if user is editing an existing event and didn't change the event poster yet
  //   - an Icon(Icons.image) if no image is selected
  dynamic image;

  // Display a bottom sheet with a circular progress indicator while the event details 
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

  // Upload event details and image to database:
  //  - if editing an existing event then use the [updateEvent] method from [DatabaseServices] class
  //  - id creating an event use [addEvent] method from [DatabaseServices] class because it generates a new unique id for the event
  void uploadEvent(Map eventData) async {
    if(widget.editModeActive) {
      String id = widget.event.eventId;
      DatabaseServices(id: id).updateEvent(Event.fromMap(eventData));
      await StorageServices().uploadEventPoster(imageFile, id);
    } else {
      DocumentReference result = await DatabaseServices().addEvent(Event.fromMap(eventData));
      await StorageServices().uploadEventPoster(imageFile, result.id);
    }
    
    // first pop; to close for bottomsheet (upload progress indicator)
    Navigator.pop(context);
    // second pop; to exit event editor and get back to club screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      //The appbar contains the title of the page and 2 buttons; one to cancel and one to confirm and upload event
      appBar: AppBar(
        title: Text('Event Editor'),
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
              // check if all inputs are valid, if so upload event
              if(_formKey.currentState.validate()) {
                if(imageFile != null){
                  uploadEvent(eventData);
                  showUploadProgressIndicator();
                } else {
                  final snackBar = SnackBar(backgroundColor: Colors.red, content: Text('Please add an image to your event.', style: TextStyle(color: Colors.white, fontSize: 20.0)));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            }
          ),
        ],
      ),

      // body contains all the Form field to fill:
      // image (event poster), starting time, ending time, event name, event location, event organizer, description  
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                imagePicker(),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                  child: Text('From', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                //starting dateTime
                dateTimePicker('from'),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                  child: Text('To', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                // ending DateTime
                dateTimePicker('to'),

                // Event title
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Event Name:', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      TextFormField(
                        initialValue: eventData['name'],
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          hintText: 'name'
                        ),
                        validator: (val) => val.isEmpty? 'A name fro the event is required': null,
                        onChanged: (val) {
                          setState(() {
                            eventData['name'] = val;
                          });
                        },
                      ),   
                    ],
                  ),
                ),

                // organizer
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Organizer:', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      TextFormField(
                        initialValue: eventData['organizer'],
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          hintText: 'organizer'
                        ),
                        validator: (val) => val.isEmpty? 'An organizer is required': null,
                        onChanged: (val) {
                          setState(() {
                            eventData['organizer'] = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // location
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location:', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      TextFormField(
                        initialValue: eventData['location'],
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          hintText: 'location'
                        ),
                        validator: (val) => val.isEmpty? 'A location is required': null,
                        onChanged: (val) {
                          setState(() {
                            eventData['location'] = val;
                          });
                        },
                      ), 
                    ],
                  ),
                ),

                //description
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
                          initialValue: eventData['description'],
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
                            eventData['description'] = val;
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

  bool validateFromToDates({DateTime fromDate, DateTime toDate}){
    return fromDate.isBefore(toDate);
  }

  
  // date time picker implementation: contains a row with two fields; one to pick date and an other to pick the time
  // used for creating both of "from" date and time and "to" date and time depending on the value of option parameter (string either "from" or "to")
  Widget dateTimePicker(String option) {

    String defaultDate = Utils.toDate(DateTime.now());
    String defaultTime = Utils.toTime(DateTime.now());
    String pickedDate = eventData[option + "Date"];
    String pickedTime = eventData[option + "Time"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: ListTile(
            title: Text(pickedDate?? defaultDate, style: TextStyle(fontSize: 13.0)),
            leading: Icon(Icons.calendar_today, color: Colors.lightBlue.shade200),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: (){
              // open calendar
              _pickDate(
                context,
                option,
                initialDate: Utils.parse(date: pickedDate?? defaultDate, time: '00:00')
              );
            },
          ),
        ),

        Expanded(
          child: ListTile(
            title: Text(eventData[option + "Time"]?? defaultTime, style: TextStyle(fontSize: 13.0)),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: (){
                List<String> time = pickedTime != null? pickedTime.split(':'): defaultTime.split(':');
              _pickTime(
                context, 
                option,
                initialTime: TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1])),
              );
            },
          ),
        ),
      ],
    );
  }

  // date picker field
  Future<void> _pickDate(BuildContext context, String option, {DateTime initialDate}) async {
    DateTime pickedDate = await showDatePicker(
      context: context, 
      initialDate: initialDate, 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100),
    );
    if(pickedDate != null) {
      setState(() {
        String stringFromDate = Utils.toDate(pickedDate);
        eventData[option + "Date"] = stringFromDate;
      }); 
    }
  }

  // time picker field
  Future<void> _pickTime(BuildContext context, String option, {TimeOfDay initialTime}) async {
    TimeOfDay pickedTime = await showTimePicker(
      context: context, 
      initialTime: initialTime, 
    );
    if(pickedTime != null) {
      setState(() {
        String stringFromTime = '${pickedTime.hour}:${pickedTime.minute}';
        String newTime = '';
        if(stringFromTime.length == 4){
          if(stringFromTime.indexOf(':') == 2) 
            newTime += stringFromTime.substring(0,3) + '0' + stringFromTime[3];
          else
            newTime = '0' + stringFromTime;
        } else if (stringFromTime.length == 3) {
          newTime += '0' + stringFromTime.substring(0,2) + '0' + stringFromTime[2];
        } else {
          newTime += stringFromTime;
        }

        eventData[option + "Time"] = newTime;
      }); 
    }
  }
  
}