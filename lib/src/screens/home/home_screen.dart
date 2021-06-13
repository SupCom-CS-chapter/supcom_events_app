import 'package:events_app/src/models/user_model.dart';
import 'package:events_app/src/screens/club/club_editor.dart';
import 'package:events_app/src/services/auth.dart';
import 'package:events_app/src/services/database.dart';
import 'package:events_app/src/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:events_app/src/models/event.dart';
import 'package:events_app/src/models/club.dart';
import 'package:events_app/src/shared/carousel.dart';
import 'package:events_app/src/shared/custom_card.dart';
import 'package:events_app/src/screens/club/club_screen.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {

  final UserModel user;
  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AuthService _auth = AuthService();
  final DatabaseServices database = DatabaseServices();

  UserData userData;

  // get current user
  @override
  void initState()  {
    super.initState();
    database.currentUserData.then((value) => userData = value);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Events"),
        backgroundColor: Color.fromARGB(255, 34, 47, 151), //Color.fromARGB(255, 15, 45, 69),
        actions: <Widget>[
          NotificationButton(),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.person),
            ),
          ),
        ],
      ),

      // create app drawer 
      drawer: MyDrawer(address: _auth.currentUser.email ,avatar: Icon(Icons.account_circle, size: 70, color: Colors.white), userData: userData),
      body:SingleChildScrollView(
        child: StreamProvider<List<Event>>(
          create: (context) => DatabaseServices().events,
          initialData: [],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //search bar
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  //color: Color.fromARGB(255, 19, 56, 82),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 34, 47, 151),
                      Color.fromARGB(255, 20, 159, 255),
                    ],
                  ),
                ),
                child:Container(
                  height: 40,
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                  padding: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: "Try searshing for an event...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      icon: Icon(Icons.search, color: Colors.grey)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topCenter, 
                child: Text(
                  "SupCom club family",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),

              // create club list on top of the screen 
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                height: size.width / 3,
                child: StreamProvider<List<Club>>(
                  create: (context) => DatabaseServices().clubs, 
                  initialData: [],
                  child: ClubList(),
                ),
              ),

              // First carousel; supposed to contain all events planned for the next 3 days  
              SizedBox(height: 20.0),
              Align(alignment: Alignment.center, child: Text("Upcoming events", style: TextStyle(fontSize: 25.0))),
              Carousel(),

              // Second Carousel; supposed to contain all events 
              SizedBox(height: 25.0),
              Align(alignment: Alignment.center, child: Text("future events", style: TextStyle(fontSize: 25.0))),
              Carousel(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 20, 159, 255),
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ClubEditor(club: Club()))).then((value) => setState((){}));
        },
      ),
    );
  }
  
  //Navigation Bar
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Gallery",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: "Calendar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "History",
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}


// this widget handels retreiving clubs and their logos from database and contructs the club list
class ClubList extends StatefulWidget {
  ClubList({
    Key key,
  }) : super(key: key);

  @override
  _ClubListState createState() => _ClubListState();
}

class _ClubListState extends State<ClubList> {

  final StorageServices _storage = StorageServices();

  Future<List<Club>> getclubList(List<Club> clubList) async {
    for(int i = 0; i<clubList.length; i++){
      if(clubList[i].logo == null){
        await _storage.getClubLogo(clubList[i].id).then((url) {clubList[i].logo = url;});
      }
    }
    return clubList;
  }

  @override
  Widget build(BuildContext context) {

    final List<Club> clubList = Provider.of<List<Club>>(context);

    return FutureBuilder(
      future: getclubList(clubList),
      builder: (context, AsyncSnapshot<List<Club>> snapshot){
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: clubList.length,
          itemBuilder: (context, index){
            return Hero(
              tag: "${clubList[index].name}",
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomCard(
                    image: clubList[index].logo,
                    borderRadius: 15.0,
                    elevation: 2,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ClubScreen(club: clubList[index])));
                    }, 
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// create the app drawer
class MyDrawer extends StatelessWidget {
  MyDrawer({
    Key key,
    @required this.address,
    @required this.avatar,
    this.userData
  }) : super(key: key);

  final Widget avatar;
  final String address;
  final UserData userData;

  final _auth = AuthService();



  @override
  Widget build(BuildContext context) {

    //UserData userData = Provider.of<UserData>(context);
    // TODO: get user profile picture
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              '${userData.firstName} ${userData.lastName}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ), 
            accountEmail: Text(
              _auth.currentUser.email,
              style: TextStyle(
                fontSize: 16,
                ),
              ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.black,
              child: avatar,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/drawer_header10.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Profile"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.rate_review_sharp),
            title: Text("Feedback"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Rate our app"),
            onTap: (){},
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Log out"),
            onTap: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
    );
  }
}


// this is supposed to caontain the logic for notification button
class NotificationButton extends StatefulWidget {

  @override
  _NotificationButtonState createState() => _NotificationButtonState();

}

class _NotificationButtonState extends State<NotificationButton> {


  Color _notifColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: IconButton(
        onPressed: (){
          setState(() {
            _notifColor = Colors.white;
          });
        },
        icon: Icon(Icons.notifications, color: _notifColor),
      ),
    );
  }
}