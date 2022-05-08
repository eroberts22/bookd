import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ArtistProfileWidget extends StatefulWidget {
  final String uid;
  const ArtistProfileWidget(this.uid, {Key? key}) : super(key: key);

  @override
  State<ArtistProfileWidget> createState() => _ArtistProfileWidgetState();
}

class _ArtistProfileWidgetState extends State<ArtistProfileWidget> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  File? _photo;
  late List<String> urlList;
  late List<Uri> activeUrlList = [];

  late DatabaseEvent event;

  @override
  void initState() {
    super.initState();
    _getProfileInfo();
  }

  Future _getProfileInfo() async {
    //String? uid = _authService.userID;
    final ref = FirebaseDatabase.instance.ref();
    event = await ref.child('Artists/${widget.uid}').once();

    //print(event.snapshot.children);
    //for (var c in event.snapshot.children) {
    //  print(c.key);
    //}

    //print(event.snapshot.child("websiteLinks").value.toString());

    String urls = event.snapshot.child("websiteLinks").value.toString();
    //for (var c in event.snapshot.child("websiteLinks").children) {
     // print(c);
    //}
    urls = urls.replaceAll("[", "");
    urls = urls.replaceAll("]", "");
    urls = urls.replaceAll(" ","");
    urlList = (urls.split(','));
    activeUrlList.clear();
    for (var c in urlList) {
      activeUrlList.add(Uri.parse(c));
    }
    //print(urlList[0]);
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
                  padding: const EdgeInsets.only(top:20, bottom: 10),
                  child: event.snapshot.child("stageName").value != null && event.snapshot.child("description").value != null ?
                  Text(event.snapshot.child("stageName").value.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30),)
                  :const Text("Please Enter Information\nin Profile Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
                    child: event.snapshot.child("stageName").value != null && event.snapshot.child("description").value != null ?
                      Text(event.snapshot.child("description").value.toString())
                      :Container(),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
                    child: event.snapshot.child("stageName").value != null && event.snapshot.child("websiteLinks").value != null ?
                      //Text(event.snapshot.child("websiteLinks").value.toString())
                      ListView.builder(
                        itemCount: activeUrlList.length,
                        shrinkWrap: true,
                        itemBuilder: 
                          (BuildContext ctxt, int index) 
                          {return InkWell(
                            child: Text(activeUrlList[index].toString()),
                            onTap: () => _launchUrl(activeUrlList[index])
                          );
                          } 
                      )
                      :Container(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: event.snapshot.child("phoneNumber").value != null ?
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                      child: Text(
                      event.snapshot.child("phoneNumber").value.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5) ),),
                    ):Container(),
                  ),
                ]),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    )));
  }
}
