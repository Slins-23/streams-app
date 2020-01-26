import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:streamhub/colors/colorscheme.dart';
import 'package:streamhub/widgets/home.dart';
import 'package:streamhub/widgets/settings.dart';
import 'dart:convert';
import 'api.dart';

// DELETE DUPLICATE STREAMS
// PROPER FILTERING AND CRAWLING
// CHANGE "SPORT" TYPE TEXT INTO IMAGE, FOOTBALL/BASKETBALL
// REFORMULATE THE STRUCTURE
// IMPLEMENT SETTINGS
// MAKE NEW TABS FOR KOREAN/ASIAN SHOWS AND STUFF LIKE THIS
// MAKE UPCOMING GAMES TAB, HAVE ONLY GAMES HAPPENING SHOW UP IN STREAMS, THE REST GOES INTO ANOTHER TAB
// MAKE TAB FOR REPLAYS
// REFRESH STREAMS
// SORT STREAMS BY NAME, PROVIDERS, ETC...

void main() async => {
      runApp(App()),
    };

loadError(dynamic one, dynamic two, BuildContext context) {
  print("Could not load data: ONE - $one | TWO - $two");
}

loadSuccess(dynamic one) {
  print("Data successfully loaded.");
}

loadData() async {
  String data = await getData("https://hub-stream.herokuapp.com/api"); // Here is the link to the Python backend.
  dynamic decodedJSON = jsonDecode(data);

  HomeState.broadcasts = new List<Broadcast>();

  for (dynamic stream in decodedJSON["streams"]) {
    Broadcast broadcast = new Broadcast(
      sport: stream["Sport"],
      ads: stream["ADS"],
      bitrate: stream["Bitrate"],
      comments: stream["Comments"],
      compatibility: stream["Compatibility"],
      coverage: stream["Coverage"],
      framerate: stream["Framerate"],
      name: stream["Name"],
      provider: stream["Provider"],
      quality: stream["Resolution"],
      startsAt: stream["Starts At"],
      teams: stream["Teams"],
      url: stream["URL"],
      fetchedAt: stream["Fetched At"],
      language: stream["Language"],
    );

    HomeState.broadcasts.add(broadcast);
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => SplashScreen(
          'assets/flare/new_loading.flr',
          (context) => View(),
          loopAnimation: 'Aura',
          until: () async => await loadData(),
          onError: (one, two) =>
              {loadError(one, two, context)}, //loadError(one, two),
          onSuccess: (one) => loadSuccess(one),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class View extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ViewState();
}

class ViewState extends State<View> {
  String activeView = "Home";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _drawer(),
      appBar: _customAppBar(),
      body: _setView(),
    );
  }

  _setView() {
    switch (activeView) {
      case "Home":
        return Home();
        break;
      case "Settings":
        return Settings();
        break;
    }
  }

  _customAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(35),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryBackground,
        elevation: 0,
        actions: <Widget>[
          Container(
            child: FlatButton(
              color: inputBackground,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.refresh,
                    color: Colors.blue,
                    size: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  Text(
                    "REFRESH",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SplashScreen(
                      'assets/flare/new_loading.flr',
                      (context) => View(),
                      loopAnimation: 'Aura',
                      until: () async => await loadData(),
                      onError: (one, two) => loadError(one, two, context),
                      onSuccess: (one) => loadSuccess(one),
                    ),
                  ),
                ),
              },
            ),
          ),
          SizedBox(
            width: 1,
          ),
          Container(
            child: FlatButton(
              color: inputBackground,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  Text(
                    "MENU",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
          ),
        ],
      ),
    );
  }

  _drawer() {
    return Drawer(
      child: Container(
        color: buttonColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _header(),
            SizedBox(
              height: 50,
            ),
            _viewItem("Home", Icons.home),
            _viewItem("Settings", Icons.settings),
          ],
        ),
      ),
    );
  }

  _header() {
    return Container(
      height: 75,
      color: inputBackground,
      child: DrawerHeader(
        child: Center(
          child: Text(
            'Tabs',
            style: TextStyle(
              color: focusColor,
              fontSize: 25,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 5,
                ),
                Shadow(
                  color: Colors.black,
                  blurRadius: 15,
                ),
                Shadow(
                  color: Colors.black,
                  blurRadius: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _viewItem(String item, IconData icon) {
    return Container(
      height: 50,
      child: RaisedButton(
        onPressed: () =>
            {setState(() => activeView = item), Navigator.pop(context)},
        focusColor: primaryBackground,
        elevation: 0,
        focusElevation: 30,
        autofocus: activeView == item ? true : false,
        color: inputBackground,
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: activeView == item ? Colors.white : gray60,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              item,
              style: TextStyle(
                color: activeView == item ? Colors.white : gray60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
