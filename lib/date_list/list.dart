import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class DateListPage extends StatefulWidget {
  DateListPage({Key key}) : super(key: key);

  @override
  DateListPageState createState() => DateListPageState();
}

class DateListPageState extends State<DateListPage> {
  var dates;
  var hour;
  bool _chipYours = false;
  bool _chipTheirs = false;
  bool _chipFiftyFifty = false;
  bool _chipAll = true;
  List<Map<dynamic, dynamic>> requestList = [];
  var dateLength = 0;
  Query requestsRef = FirebaseDatabase.instance.reference().child("Requests");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text("Dates Nearby",
                  style: TextStyle(
                      fontSize: 21,
                      color: Colors.pink,
                      fontStyle: FontStyle.normal)),
              new Container(
                margin: new EdgeInsets.only(bottom: 20.0),
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: new Text(
                    dateLength.toString(),
                    style: new TextStyle(fontSize: 12.0),
                  ),
                ),
                decoration: new BoxDecoration(
                    color: Colors.pink, shape: BoxShape.circle),
              )
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: new Column(
          children: <Widget>[
            Wrap(
              children: [
                FilterChip(
                  label: Text('All'),
                  selected: _chipAll,
                  onSelected: (bool selected) {
                    _chipFiftyFifty = false;
                    _chipTheirs = false;
                    _chipYours = false;
                    setState(() {
                      _chipAll = selected;
                      requestsRef = FirebaseDatabase.instance
                          .reference()
                          .child("Requests")
                          .orderByChild("timeStamp");
                    });
                  },
                  checkmarkColor: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                FilterChip(
                  label: Text('Theirs'),
                  selected: _chipTheirs,
                  onSelected: (bool selected) {
                    _chipFiftyFifty = false;
                    _chipAll = false;
                    _chipYours = false;
                    setState(() {
                      _chipTheirs = selected;
                      requestsRef = FirebaseDatabase.instance
                          .reference()
                          .child("Requests")
                          .orderByChild("treatTypeId")
                          .equalTo(0);
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FilterChip(
                  label: Text('Yours'),
                  selected: _chipYours,
                  onSelected: (bool selected) {
                    _chipFiftyFifty = false;
                    _chipTheirs = false;
                    _chipAll = false;
                    setState(() {
                      _chipYours = selected;
                      requestsRef = FirebaseDatabase.instance
                          .reference()
                          .child("Requests")
                          .orderByChild("treatTypeId")
                          .equalTo(1);
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FilterChip(
                  label: Text('50/50'),
                  selected: _chipFiftyFifty,
                  onSelected: (bool selected) {
                    _chipTheirs = false;
                    _chipAll = false;
                    _chipYours = false;
                    setState(() {
                      _chipFiftyFifty = selected;
                      if (requestsRef
                              .orderByChild("treatTypeId")
                              .equalTo(2)
                              .once() !=
                          null) {
                        requestsRef = FirebaseDatabase.instance
                            .reference()
                            .child("Requests")
                            .orderByChild("treatTypeId")
                            .equalTo(2);
                      }
                    });
                  },
                ),
              ],
            ),
            Container(
              child: new Expanded(
                child: new StreamBuilder(
                    stream: requestsRef.onValue,
                    builder:
                        (BuildContext context, AsyncSnapshot<Event> event) {
                      requestList.clear();
                      if (event.hasData) {
                        Map<dynamic, dynamic> values =
                            event.data.snapshot.value;
                        if (values != null)
                          values.forEach((key, value) {
                            print(value);
                            requestList.add(value);
                          });
                      }
                      return new ListView.builder(
                        itemCount: requestList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var date = requestList[index];
                          var time;
                          var assetSrc;
                          dateLength = requestList.length;
                          hour = int.parse(date['hour'].toString());
                          if (hour > 12) {
                            hour -= 12;
                            time = date['dateFormat'] +
                                " at " +
                                hour.toString() +
                                ":" +
                                date['minutes'] +
                                " pm";
                          } else if (hour == 0) {
                            hour += 12;
                            time = date['dateFormat'] +
                                " at " +
                                hour.toString() +
                                ":" +
                                date['minutes'] +
                                " am";
                          } else if (hour < 12) {
                            time = date['dateFormat'] +
                                " at " +
                                hour.toString() +
                                ":" +
                                date['minutes'] +
                                " am";
                          }

                          if (int.parse(date['place_type'].toString()) == 0) {
                            assetSrc = 'assets/ic_restaurant.png';
                          } else if (int.parse(date['place_type'].toString()) ==
                              1) {
                            assetSrc = 'assets/ic_cinema.png';
                          } else if (int.parse(date['place_type'].toString()) ==
                              2) {
                            assetSrc = 'assets/ic_club.png';
                          } else if (int.parse(date['place_type'].toString()) ==
                              3) {
                            assetSrc = 'assets/ic_cinema.png';
                          }
                          return new Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              child: new Container(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  backgroundBlendMode: BlendMode.darken,
                                  image: DecorationImage(
                                    image: NetworkImage(date["placeImageUrl"]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: 100,
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      backgroundBlendMode: BlendMode.darken,
                                    )),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            margin: new EdgeInsets.all(10.0),
                                            alignment: Alignment.center,
                                            height: 60,
                                            width: 60,
                                            decoration: new BoxDecoration(
                                                color: Colors.pink,
                                                image: new DecorationImage(
                                                  image: NetworkImage(
                                                      date['profileImageUrl']),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: new BorderRadius
                                                        .all(
                                                    new Radius.circular(50.0)),
                                                border: new Border.all(
                                                  color: Colors.pink,
                                                  width: 2.0,
                                                ))),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Text(
                                                date['name'] +
                                                    ", " +
                                                    date['age'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.white)),
                                            new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                new Icon(
                                                  Icons.location_on,
                                                  color: Colors.pink,
                                                  size: 24.0,
                                                ),
                                                new SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                      date['place_name'] +
                                                          " ,2km",
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16)),
                                                ),
                                                new SizedBox(
                                                  width: 15.0,
                                                ),
                                              ],
                                            ),
                                            new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                new Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.pink,
                                                  size: 24.0,
                                                ),
                                                new Text(time,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16)),
                                                new SizedBox(
                                                  width: 25.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Image.asset(
                                          assetSrc,
                                          color: Colors.pink,
                                          width: 48,
                                          height: 48,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ));
                        },
                      );
                    }),
              ),
            )
          ],
        ));
  }
}
