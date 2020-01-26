import 'package:flutter/material.dart';
import 'package:streamhub/colors/colorscheme.dart';
import 'package:url_launcher/url_launcher.dart';

class Broadcast {
  final String sport;
  final String provider;
  final String teams;
  final String name;
  final String startsAt;
  final String quality;
  final String framerate;
  final String bitrate;
  final String coverage;
  final String compatibility;
  final String ads;
  final String comments;
  final String url;
  String fetchedAt;
  final String language;

  Broadcast({
    @required this.sport,
    @required this.provider,
    @required this.teams,
    @required this.name,
    @required this.startsAt,
    @required this.quality,
    @required this.framerate,
    @required this.bitrate,
    @required this.coverage,
    @required this.compatibility,
    @required this.ads,
    @required this.comments,
    @required this.url,
    @required this.fetchedAt,
    @required this.language,
  });

}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  static List<Broadcast> broadcasts = new List<Broadcast>();

  String filter = "all";

  @override
  void initState() {
    print("Initializing state...");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _loadMenu(),
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
                color: inputBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(15)),
            width: 750,
            height: 25,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Container(
                  child: Text(
                    "Sport",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  width: 7.5,
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                  ),
                  child: Text(
                    "Provider",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 61.0,
                    right: 55.0,
                  ),
                  child: Text(
                    "Teams",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 34.0,
                    right: 30.0,
                  ),
                  child: Text(
                    "Coverage",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    "Lang",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    "FPS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 12.0,
                    right: 10.0,
                  ),
                  child: Text(
                    "ADS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                  ),
                  child: Text(
                    "Starts",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Text(
                    "Updated",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          broadcasts.length > 0 ? _loadStreams() : _streamsNotFound(),
        ],
      ),
      backgroundColor: primaryBackground,
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch: $url");
    }
  }

  _loadStreams() {
    return Container(
      width: 775,
      height: 275,
      padding: EdgeInsets.only(top: 20),
      child: Scrollbar(
        child: ListView.builder(
          itemCount: filter == "all"
              ? broadcasts.length
              : broadcasts
                  .where((broadcast) => broadcast.sport == filter)
                  .length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return filter == "all"
                ? _unfilteredStreams(index)
                : _filteredStreams(
                    index,
                    broadcasts
                        .where((broadcast) => broadcast.sport == filter)
                        .toList());
          },
        ),
      ),
    );
  }

  _streamsNotFound() {
    return Container(
      padding: EdgeInsets.only(top: 100),
      child: Text(
        "Streams not found",
        style: TextStyle(
          color: Colors.red,
          fontSize: 25,
        ),
      ),
    );
  }

  _loadMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 150,
        ),
        Container(
          height: 112,
          child: RaisedButton(
            onPressed: () => setState(() => filter = "Basketball"),
            elevation: 30,
            color: inputBackground,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/logos/nba.jpg',
                  width: 63,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "NBA",
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Roboto Condensed',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 75,
        ),
        Container(
          height: 110,
          child: RaisedButton(
            onPressed: () async => {
              setState(() => filter = "Football"),
            },
            color: inputBackground,
            elevation: 30,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/logos/football.jpg',
                  width: 63,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Football",
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'Roboto Condensed',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _unfilteredStreams(int index) {
    return Column(
      children: <Widget>[
        Container(
          padding: index == broadcasts.length - 1
              ? const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  bottom: 3.0,
                )
              : const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 3.0),
          height: 25,
          child: RaisedButton(
            onPressed: () => _launchUrl(broadcasts[index].url),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            elevation: 5,
            color: inputBackground
                .withRed(
                  ((inputBackground.red * 1.4).round()),
                )
                .withGreen(
                  ((inputBackground.green * 1.4).round()),
                )
                .withBlue(
                  ((inputBackground.blue * 1.4).round()),
                ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 7.5,
                ),
                Container(
                  width: 22,
                  child: Image.asset(
                    'assets/images/balls/${broadcasts[index].sport.toLowerCase()}.jpg',
                    alignment: Alignment.center,
                  ),
                  transform: Matrix4.translationValues(-5, 0, 0),
                ),
                SizedBox(
                  width: 7.5,
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 96,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      broadcasts[index].provider,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gray,
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 155,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      broadcasts[index].teams,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gray,
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 118,
                  child: Text(
                    broadcasts[index].coverage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 49,
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    _parseLanguage(broadcasts[index].language),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 45,
                  child: Text(
                    broadcasts[index].framerate,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 46,
                  child: Text(
                    broadcasts[index].ads,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 85,
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    broadcasts[index].startsAt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    broadcasts[index].fetchedAt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto Condensed',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  transform: Matrix4.translationValues(12, 0, 0),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  _filteredStreams(int index, List<Broadcast> filteredBroadcasts) {
    return Column(
      children: <Widget>[
        Container(
          padding: index == filteredBroadcasts.length - 1
              ? const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  bottom: 3.0,
                )
              : const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 3.0),
          height: 25,
          child: RaisedButton(
            onPressed: () => _launchUrl(filteredBroadcasts[index].url),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            elevation: 5,
            color: inputBackground
                .withRed(
                  ((inputBackground.red * 1.4).round()),
                )
                .withGreen(
                  ((inputBackground.green * 1.4).round()),
                )
                .withBlue(
                  ((inputBackground.blue * 1.4).round()),
                ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 7.5,
                ),
                Container(
                  width: 22,
                  child: Image.asset(
                    'assets/images/balls/${filteredBroadcasts[index].sport.toLowerCase()}.jpg',
                    alignment: Alignment.center,
                  ),
                  transform: Matrix4.translationValues(-5, 0, 0),
                ),
                SizedBox(
                  width: 7.5,
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 96,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      filteredBroadcasts[index].provider,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gray,
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 155,
                  padding: EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      filteredBroadcasts[index].teams,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gray,
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 118,
                  child: Text(
                    filteredBroadcasts[index].coverage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 49,
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    _parseLanguage(filteredBroadcasts[index].language),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 45,
                  child: Text(
                    filteredBroadcasts[index].framerate,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 46,
                  child: Text(
                    filteredBroadcasts[index].ads,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  width: 85,
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    filteredBroadcasts[index].startsAt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.20),
                  width: 1.5,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Text(
                    filteredBroadcasts[index].fetchedAt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gray,
                      fontSize: 13,
                      fontFamily: 'Roboto Condensed',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  transform: Matrix4.translationValues(12, 0, 0),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  _parseLanguage(String language) {
    if (language == "Portuguese") {
      return "PT";
    } else if (language == "English") {
      return "EN";
    } else if (language == "Spanish") {
      return "ES";
    } else {
      return language;
    }
  }
}
