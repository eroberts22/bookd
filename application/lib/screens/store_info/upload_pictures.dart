import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:convert';

import 'package:application/services/auth.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  // To store the images
  FirebaseStorage storage = FirebaseStorage.instance;

  // For authenticating user
  final AuthService _authService = AuthService();

  // To update user info
  FirebaseDatabase database = FirebaseDatabase.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print("No Image Selected");
      }
    });
  }

  Future imageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print("No Image Selected");
      }
    });
  }

  // Upload the _photo path to firebase storage
  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = "Images/$fileName";

    try {
      // Create a new storage reference pointing to the unique filePath
      await storage.ref(destination).putFile(_photo!);
      print("Successfully uploaded file $fileName");

      String? uid = _authService.userID;
      // Add the url to filename to the current user's list of images
      // Get the user's type of profile
      DatabaseEvent userEvent = await database.ref("Users/$uid").once();
      // Attempts to access the value, but if it is null we access the empty map
      String? profileType =
          jsonDecode(jsonEncode(userEvent.snapshot.value))["profileType"];

      // Get reference to user account
      if (profileType == "artist") {
        DatabaseReference profileRef = database.ref("Artists/$uid");
        print(uid);

        DatabaseEvent profileEvent = await profileRef.once();
        print(jsonDecode(jsonEncode(profileEvent.snapshot.value)));

        // copy the already existing images
        List<String>? prevImages =
            (jsonDecode(jsonEncode(profileEvent.snapshot.value))["images"]
                as List<String>?);
        // add new image
        if (prevImages == null) {
          prevImages = [fileName];
          print("Creating image list");
        } else {
          prevImages.add(fileName);
          print("Appending to image list");
        }

        Map<String, Object> updateMap = {"images": prevImages};
        // Update the node
        profileRef.update(updateMap);

        print("Added image for $profileType $uid");
      } else if (profileType == "venue") {
        DatabaseReference profileRef = database.ref("Venues/$uid");

        DatabaseEvent profileEvent = await profileRef.once();
        // copy the already existing images
        List<String>? prevImages =
            (jsonDecode(jsonEncode(profileEvent.snapshot.value))["images"]
                as List<String>?);
        // add new image
        if (prevImages == null) {
          prevImages = [fileName];
          print("Creating image list");
        } else {
          prevImages.add(fileName);
          print("Appending to image list");
        }

        Map<String, Object> updateMap = {"images": prevImages};
        // Update the node
        profileRef.update(updateMap);

        print("Added image for $profileType $uid");
      }
    } catch (e) {
      print("Error occurred uploading file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: const Text('Upload Image'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account');
              },
            ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
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
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
