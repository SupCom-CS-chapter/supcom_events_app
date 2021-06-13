import 'dart:math';
import 'package:events_app/src/screens/event/event_editor.dart';
import 'package:events_app/src/services/database.dart';
import 'package:events_app/src/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:events_app/src/models/event.dart';
import 'package:events_app/src/models/club.dart';
import 'package:events_app/src/shared/custom_card.dart';
import 'package:events_app/src/screens/event/event_screen.dart';
import 'package:provider/provider.dart';


// At the top of the home page, there is a list of the clubs present in Sup'Com,
// when a club card is clicked, users are sent to an instance of this widget [ClubScreen] which receives all club details
// and searchs for all events belonging to this club
class ClubScreen extends StatefulWidget {

  final Club club;

  ClubScreen({this.club});

  @override
  _ClubScreenState createState() => _ClubScreenState();
}


class _ClubScreenState extends State<ClubScreen> {

  @override
  Widget build(BuildContext context){
    
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            // place the background on top of the club screen and place the club logo on top
            Container(
              width: size.width,
              height: size.width * 7 / 9,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/club_bg.png"),
                  ),
                ),
              child: Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: "${widget.club.name}",
                  child: CircleAvatar(
                    radius: size.width / 4,
                    backgroundImage: NetworkImage(widget.club.logo),
                  ),
                ),
              ),
            ),

            // create club descritpion and add an animation
            TweenAnimationBuilder(
              child: _buildClubDescriptionCard(context, "We Are the Home for Computer Science and Engineering Leaders\n\nThe IEEE Computer Society is the premier source for information, inspiration, and collaboration in computer science and engineering. Connecting members worldwide, the Computer Society empowers the people who advance technology by delivering tools for individuals at all stages of their professional careers. \n\nOur trusted resources include international conferences, peer-reviewed publications, a robust digital library, globally recognized standards, and continuous learning opportunities."),
              tween: Tween<double>(begin: 0, end: 1), 
              duration: Duration(milliseconds: 600), 
              builder: (BuildContext context, double _val, Widget child){
                return Opacity(
                  opacity: 1 - cos(pi/2 * _val),
                  child: Padding(
                    padding: EdgeInsets.only(top:15 + 10 * sin(pi/2 * (1-_val))),
                    child: child,
                  ),
                );
              }
            ),

            // search for events organized by this club and display them 2 for every row
            SizedBox(height: 20.0),
            Divider(color: Colors.grey),
            Text(
              "Events",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: StreamProvider<List<Event>>(
                initialData: [],
                create: (context) => DatabaseServices().eventListFromConstraint('organizer', widget.club.alias),
                child: EventGallery(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 20, 159, 255),
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EventEditor(event: Event(organizer: widget.club.alias)))).then((value) => setState((){}));
        },
      ),
    );
  }

  Widget _buildClubDescriptionCard(BuildContext context, String description){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Text(
            "About Us",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            widget.club.description,
            style: TextStyle(
            fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}


// this class handels getting the correct events from database and retreives all event posters from cloud storage 
// then place them in a grid of width 2
class EventGallery extends StatelessWidget {

  final StorageServices _storage = StorageServices();

  Future<List<Event>> getEventList(List<Event> eventList) async {
    for(int i = 0; i<eventList.length; i++){
      if(eventList[i].poster == null){
        await _storage.getEventPoster(eventList[i].eventId).then((url) {eventList[i].poster = url;});
      }
    }
    return eventList;
  }


  @override
  Widget build(BuildContext context) {
    
    final List<Event> eventList = Provider.of<List<Event>>(context);

    

    return FutureBuilder<List<Event>>(
      future: getEventList(eventList),
      builder: (context, AsyncSnapshot<List<Event>> snapshot) {
        switch (snapshot.connectionState) {
         case ConnectionState.waiting: return Container(height : 100, child: Center(child: CircularProgressIndicator()));
         default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            else{
              List<Event> eventList = snapshot.data;
              return GridView.count(
                crossAxisCount: 2,
                children: List.generate(eventList.length, (index) {
                return CustomCard(
                  image: eventList[index].poster,//"assets/events/place_holder.png", 
                  borderRadius: 10.0, 
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => EventScreen(event: eventList[index])));}
              );
            }),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          );
        }}
      },
    );
  }
} 
