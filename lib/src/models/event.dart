class Event{
  String eventId;
  String name;
  String poster;
  String organizer;
  String location;
  String description;
  String fromDate;
  String toDate;
  String fromTime;
  String toTime;

  Event({
    this.eventId,
    this.name, 
    this.poster, 
    this.organizer, 
    this.location, 
    this.description,
    this.fromDate,
    this.toDate,
    this.fromTime,
    this.toTime,
  });

  @override
  String toString() {
    return """{
      'uid': $eventId,
      'name': $name,
      'organizer': $organizer,
      'poster': $poster,
      'description': $description,
      'loaction': $location,
      'fromDate': $fromTime,
      'toDate': $toDate,
      'fromTime': $fromTime,
      'toTime': $toTime
    }""";
  }
  
  // convert an event into a map 
  Map<String, dynamic> toMap() {
    return {
      'id': eventId,
      'name': name,
      'organizer': organizer,
      'poster': poster,
      'description': description,
      'location': location,
      'fromDate': fromDate,
      'toDate': toDate,
      'fromTime': fromTime,
      'toTime': toTime
    };
  }

  // create an event from a map
  factory Event.fromMap(Map map){
    return Event(
      eventId: map['eventId'],
      name: map['name'],
      organizer: map['organizer'],
      location: map['location'],
      description: map['description'],
      fromDate: map['fromDate'],
      toDate: map['toDate'],
      fromTime: map['fromTime'],
      toTime: map['toTime'],
    );
  }

  

}

//examples of events for testing (hard coded for now)
// List<Event> events = [
//     Event(name: 'Online Flutter Workshop ', image: 'cs flutter.jpg', organizer:  Club(name: "IEEE CS Chapter", alias: "CS",    logo: "cs.png", description: ""), location: "Sup'Com", description: ""),
//     Event(name: 'GitHub Workshop Program', image: 'git.png', organizer:  Club(name: "IEEE CS Chapter", alias: "CS",    logo: "cs.png", description: ""), location: "Sup'Com", description: ""),
//     Event(name: 'Hack For Earth', image: 'hack for earth.jpg', organizer: Club(name: "IEEE", alias: "IEEE",  logo: "ieee.jpeg", description: ""), location: "Online", description: ""),
//     Event(name: 'How to Approch Machine Learning Projects', image: 'IEEE ML.jpg', organizer: Club(name: "IEEE", alias: "IEEE",  logo: "ieee.jpeg", description: ""), location: "Online", description: ""),
//     Event(name: 'Leading General Assembly', image: 'leading general assembly.png', organizer: Club(name: "Leading", alias: "Leading", logo: "leading.png", description: ""), location: "Sup'Com", description: ""),
//     Event(name: 'Machine Learning', image: 'machine learning.png', organizer: Club(name: "NA", alias: "NA", logo: "NA", description: ""), location: "Sup'Com", description: ""),
//     Event(name: 'Motivation & self development', image: 'motivation & self development.png', organizer: Club(name: "NATEG", alias: "NATEG", logo: "nateg.png", description: ""), location: "Sup'Com", description: ""),
//     Event(name: 'Webinary', image: 'nateg webinary.jpg', organizer: Club(name: "NATEG", alias: "NATEG", logo: "nateg.png", description: ""), location: "Sup'Com", description: ""),
//     Event(name: 'Social Entreprenership & Social Solidarity Economy', image: 'social solidarity.jpg', organizer: Club(name: "ENACTUS", alias: "ENACTUS", logo: "enactus.png", description: ""), location: "Sup'Com", description: ""),
//     Event(name: 'We Run', image: 'we run.jpg', organizer: Club(name: "SupFit", alias: "SupFit", logo: "supfit.png", description: ""), location: "Sup'Com", description: ""),
//     Event(name: 'Online Web Development Workshop', image: 'web dev.jpg', organizer: Club(name: "IEEE CS Chapter", alias: "CS",    logo: "cs.png", description: ""), location: "Sup'Com", description: ""),
//   ];