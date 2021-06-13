import 'package:events_app/src/screens/event/event_editor.dart';
import 'package:flutter/material.dart'; 
import 'package:events_app/src/models/event.dart';

class EventScreen extends StatefulWidget {

  final Event event;
  EventScreen({this.event});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _favourite = false;

  // this methos changes the color of the favourite button of an event 
  // (red it favourited and grey if not) 
  void _changeHeart(){
    setState(() {
      _favourite = !_favourite;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.event.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.event.organizer,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: _changeHeart,
            icon: Icon(Icons.favorite),
            color: _favourite ? Colors.red: Colors.grey.shade300,
          ),
          Text(_favourite ? '1': '0'),
        ],
      ),
    );

 

    Color color = Theme.of(context).primaryColor;

 
    // create the buttons below the event poster 
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'CALL'),
          _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          _buildButtonColumn(color, Icons.share, 'SHARE'),
        ],
      ),
    );

 
  // event description
  Widget textSection = Container(
    padding: const EdgeInsets.all(32),
    child: Text(
      widget.event.description,
      softWrap: true,
    ),
  );

  return Scaffold(
    backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                widget.event.poster,
                fit: BoxFit.fill,
              ),
            ),
            
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EventEditor(event: widget.event)));
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: (){}, icon: Icon(icon), color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
