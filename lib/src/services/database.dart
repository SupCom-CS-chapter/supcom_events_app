import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app/src/models/user_model.dart';
import 'package:events_app/src/models/club.dart';
import 'package:events_app/src/models/event.dart';
import 'package:events_app/src/services/storage.dart';
import 'package:events_app/src/services/auth.dart';

class DatabaseServices {

  final String id;

  DatabaseServices({this.id});

  final CollectionReference eventCollection = FirebaseFirestore.instance.collection('events');
  final CollectionReference clubCollection = FirebaseFirestore.instance.collection('clubs');
  final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('userData');

  // update user data if it exists or create a new one if user registered for the first time
  Future<void> updateUserData(String firstName, String lastName, String university) async {
    return await userDataCollection.doc(id).set({
        'firstName': firstName,
        'lastName': lastName,
        'university': university,
      }
    );
  }

  Future<UserData> get currentUserData async {
    DocumentSnapshot result = await userDataCollection.doc( AuthService().currentUser.uid).get();
    return _userDataFromSnapshot(result);
  }

  Future<void> updateEvent(Event event) async {
    return await eventCollection.doc(id).set({
        'name': event.name,
        'organizer': event.organizer,
        'description': event.description,
        'location': event.location,
        'fromDate': event.fromDate,
        'toDate': event.toDate,
        'fromTime': event.fromTime,
        'toTime': event.toTime,
    });
  }

  Future<DocumentReference> addEvent(Event event) async {
    return await eventCollection.add({
      'name': event.name,
      'organizer': event.organizer,
      'description': event.description,
      'location': event.location,
      'fromDate': event.fromDate,
      'toDate': event.toDate,
      'fromTime': event.fromTime,
      'toTime': event.toTime,
    });
  }

  Event _eventFromSnapshot(DocumentSnapshot snapshot) {
    
    return Event(
      eventId: snapshot.reference.id,
      name: snapshot['name'],
      organizer: snapshot['organizer'],
      description: snapshot['description'],
      location: snapshot['location'],
      fromDate: snapshot['fromDate'],
      toDate: snapshot['toDate'],
      fromTime: snapshot['fromTime'],
      toTime: snapshot['toTime'],
    );
  }

  //get a single spe event from data
  Future<Event> get event async {
    final result = await eventCollection.doc(id).get();
    if(result.exists){
      Event event = _eventFromSnapshot(result);
      String eventId = result.reference.id;
      String posterURL =  await StorageServices().getEventPoster(eventId);
      event.poster = posterURL;
      return event;
    } else {
      return null;
    }
  }

  // create event list from firestore snapshot sorted by date
  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    List<Event> result = snapshot.docs.map(_eventFromSnapshot).toList();
    // result.forEach(
    //   (event) async {
    //     String posterURL = await StorageServices().getEventPoster(event.eventId);
    //     event.poster = posterURL;
    //   }
    // );
    return result;
  } 

  // get all events complying to a certain constraint
  Stream<List<Event>> eventListFromConstraint(String field, String constraint) {
    return eventCollection.where(field, isEqualTo: constraint)
      .snapshots()
      .map(_eventListFromSnapshot);
  }

  // get event stream
  Stream<List<Event>> get events {
    return eventCollection.snapshots().map(_eventListFromSnapshot);
  }

  // 
  Future<DocumentReference> addClub(Club club) async {
    return await clubCollection.add({
      'name': club.name,
      'alias': club.alias,
      'description': club.description,
    });
  }

  // create club list from firestore snapshot
  List<Club> _clubListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map( (doc) {
      return Club(
        id: doc.id,
        name: doc['name'],
        description: doc['description'],
        alias: doc['alias'],
      );
    }).toList();
  }

  // get club stream
  Stream<List<Club>> get clubs {
    return clubCollection.snapshots().map(_clubListFromSnapshot);
  }

  // create instance of userData class from document snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: id,
      firstName: snapshot['firstName'],
      lastName: snapshot['lastName'],
      university: snapshot['university'],
    );
  }

  // get UserData stream
  Stream<UserData> get userDataStream {
    return userDataCollection.doc(id).snapshots()
      .map(_userDataFromSnapshot);
  }
}