import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:events_app/src/models/event.dart';
import 'package:events_app/src/shared/custom_card.dart';
import 'package:events_app/src/screens/event/event_screen.dart';
import 'package:provider/provider.dart';
import 'package:events_app/src/services/storage.dart';


class Carousel extends StatelessWidget {

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
            } else {
              List<Event> eventList = snapshot.data;
              return CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: 0,
                  //autoPlay: true,
                ),
                items: _buildItemList(context, eventList),
              );
            }
        }
      },
    );
  }

  List<CustomCard> _buildItemList(BuildContext context, List<Event> eventList){
    return eventList.map((event) => CustomCard(
          elevation: 1,
          image: event.poster,
          borderRadius: 10.0, 
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EventScreen(event: event)));
          },
        ),
      
    ).toList();
  }

}