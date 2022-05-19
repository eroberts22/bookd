import 'package:application/screens/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_theme.dart';

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
  FirebaseStorage storage = FirebaseStorage.instance;
  Uint8List? profilePic;
  String? venueType;

  late List<String> urlList;
  late List<Uri> activeUrlList = [];

  late DatabaseEvent event;

  @override
  void initState() {
    super.initState();
    _getProfileInfo();
    getProfilePic();
  }

  void getProfilePic() async {
    DatabaseEvent profilePicEvent =
        await database.ref().child("Venues/${widget.uid}/profileImage").once();
    storage
        .ref()
        .child("Images/${widget.uid}/${profilePicEvent.snapshot.value}")
        .getData(10000000)
        .then((data) => setState(() {
              profilePic = data!;
            }));
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
                Card(
                    child: SizedBox(
                        height: 200.0,
                        child: profilePic != null
                            ? Image.memory(profilePic!, fit: BoxFit.cover)
                            : const Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                ),
                              ))),
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
                                child: Text(
                                  activeUrlList[index].toString(),
                                  style: TextStyle(
                                      color: AppTheme.colors.ternary,),
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
