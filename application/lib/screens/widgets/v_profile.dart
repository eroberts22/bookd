import 'package:application/screens/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class VenueProfileWidget extends StatefulWidget {
  // //make it so the uid is set by passing it into this widget. access uid by using "widget.uid"
  final String uid;
  const VenueProfileWidget(this.uid, {Key? key}) : super(key: key);
  //const VenueProfileWidget({Key? key}) : super(key: key);
  @override
  State<VenueProfileWidget> createState() => _VenueProfileWidgetState();
}

class _VenueProfileWidgetState extends State<VenueProfileWidget> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  File? _photo;
  String? img;
  String? venueType;

  late List<String> urlList;
  late List<Uri> activeUrlList = [];

  late DatabaseEvent event;

  @override
  void initState() {
    super.initState();
    _getProfileInfo();
  }

  Future _getProfileInfo() async {
    // String? uid = _authService
    //     .userID; //TODO: uid here should be passed in from explore page card (see contructor)
    String uid = widget.uid;
    final ref = FirebaseDatabase.instance.ref();
    event = await ref.child('Venues/$uid').once();
/*
    print(event.snapshot.children);
    for (var c in event.snapshot.children) {
      print(c.key);
    }

    print(event.snapshot.child("tags").children);
    for (var c in event.snapshot.child("tags").children) {
      //print(c.value);
      if (c.value.toString() == "true") {
        print(c.key);
        venueType = c.key;
      }
    }*/

    String urls = event.snapshot.child("websiteLinks").value.toString();
    //for (var c in event.snapshot.child("websiteLinks").children) {
    // print(c);
    //}
    urls = urls.replaceAll("[", "");
    urls = urls.replaceAll("]", "");
    urls = urls.replaceAll(" ", "");
    urlList = (urls.split(','));
    activeUrlList.clear();
    for (var c in urlList) {
      activeUrlList.add(Uri.parse(c));
    }
  }

  void _launchUrl(_url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: FutureBuilder(
          future: _getProfileInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                  child: Column(children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.orangeAccent,
                  child: _photo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _photo!,
                            //"gs://bookd-4bdd3.appspot.com/Images/$img",
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: event.snapshot.child("name").value != null &&
                          event.snapshot.child("description").value != null
                      ? Text(
                          event.snapshot.child("name").value.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        )
                      : const Text(
                          "Please Enter Information\nin Profile Settings",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: event.snapshot.child("name").value != null &&
                            event.snapshot.child("description").value != null
                        ? Text(event.snapshot
                            .child("description")
                            .value
                            .toString())
                        : Container(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 30, right: 30, bottom: 10),
                  child: event.snapshot.child("name").value != null &&
                          event.snapshot.child("websiteLinks").value != null
                      ? ListView.builder(
                          itemCount: activeUrlList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                                //MaterialStateProperty.all<Color>(Colors.cyan),
                                child: Text(
                                  activeUrlList[index].toString(),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 9, 133, 150)),
                                ),
                                onTap: () => _launchUrl(activeUrlList[index]));
                          })
                      : Container(),
                ),
                SizedBox(
                  width: double.infinity,
                  child: event.snapshot.child("streetAddress").value != null &&
                          event.snapshot.child("city").value != null &&
                          event.snapshot.child("zipCode").value != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 30, right: 30, bottom: 10),
                          child: Text(
                            event.snapshot
                                    .child("streetAddress")
                                    .value
                                    .toString() +
                                " " +
                                event.snapshot.child("city").value.toString() +
                                " " +
                                event.snapshot
                                    .child("zipCode")
                                    .value
                                    .toString(),
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        )
                      : Container(),
                ),
                SizedBox(
                  width: double.infinity,
                  child: event.snapshot.child("phoneNumber").value != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 10),
                          child: Text(
                            event.snapshot
                                .child("phoneNumber")
                                .value
                                .toString(),
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        )
                      : Container(),
                ),
                SizedBox(
                  width: 400,
                  height: 400,
                  child: BookdCalendar(widget.uid),
                ),
              ]));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    )));
  }
}
