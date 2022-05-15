import 'package:flutter/material.dart';
import 'package:application/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class ArtistProfileWidget extends StatefulWidget {
  final String uid;
  const ArtistProfileWidget(this.uid, {Key? key}) : super(key: key);

  @override
  State<ArtistProfileWidget> createState() => _ArtistProfileWidgetState();
}

class _ArtistProfileWidgetState extends State<ArtistProfileWidget> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Uint8List? profilePic;
  late List<String> urlList;
  late List<Uri> activeUrlList = [];

  late DatabaseEvent event;

  @override
  void initState() {
    super.initState();
    _getProfileInfo();
    getProfilePic();
  }
  void getProfilePic() async{
    DatabaseEvent profilePicEvent = await database.ref().child("Artists/${widget.uid}/profileImage").once();
    storage.ref().child("Images/${widget.uid}/${profilePicEvent.snapshot.value}").getData(10000000).then((data) =>
      setState((){
        profilePic = data!;
      }
    ));
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
    urls = urls.replaceAll(" ", "");
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
                  Card(
                  child: SizedBox(
                    height: 200.0,
                    child: profilePic != null ? Image.memory(
                      profilePic!,
                      fit: BoxFit.cover
                    ): const Center(
                        child: CircularProgressIndicator(),
                      ) 
                  )
                ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: event.snapshot.child("stageName").value != null &&
                            event.snapshot.child("description").value != null
                        ? Text(
                            event.snapshot.child("stageName").value.toString(),
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
                    child: event.snapshot.child("stageName").value != null &&
                            event.snapshot.child("description").value != null
                        ? Text(event.snapshot
                            .child("description")
                            .value
                            .toString())
                        : Container(),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 30, right: 30, bottom: 10),
                    child: event.snapshot.child("stageName").value != null &&
                            event.snapshot.child("websiteLinks").value != null
                        ?
                        //Text(event.snapshot.child("websiteLinks").value.toString())
                        ListView.builder(
                            itemCount: activeUrlList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return InkWell(
                                  child: Text(
                                    activeUrlList[index].toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 9, 133, 150)),
                                  ),
                                  onTap: () =>
                                      _launchUrl(activeUrlList[index]));
                            })
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
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          )
                        : Container(),
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
