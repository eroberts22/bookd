import 'dart:typed_data';
import 'package:application/theme/app_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

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

  var type; // type of account, used for navigation
  var errorMsg = null;
  List<Uint8List> allImages = [];
  List<String> imageNames = [];
  File? _photo; //photo being uploaded

  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    _getDatabaseProfileType();
    getAllImages();
  }

  void getAllImages() async {
    String uid = _authService.userID.toString();
    allImages = []; //reset all images to have no images in it
    imageNames = [];
    ListResult result = await storage.ref().child("Images/$uid").listAll();
    //for each image in storage, create a reference for it
    //then add the data at the reference to the global list of all image data
    result.items.forEach((Reference imageRef){
      imageRef.getData(10000000).then((data) =>
        setState((){
          allImages.add(data!);
          imageNames.add(imageRef.name);
        })
      ).catchError((e) =>
        setState((){
          errorMsg = e.error;
        })
      );
    });
  }

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
  
  void setAsProfilePic(int imageIndex) async {
    String uid = _authService.userID.toString();
    DatabaseEvent userEvent = await database.ref("Users/$uid").once();
    String? profileType = userEvent.snapshot.child("profileType").value.toString();
    if(profileType == "artist"){
      profileType = "Artists";
    }
    else{
      profileType = "Venues";
    }
    //set profileImage field to be the selected image.
    database.ref().child("$profileType/$uid").update({"profileImage" : imageNames[imageIndex]});

  }

  // Upload the _photo path to firebase storage
  Future uploadFile() async {
    String uid = _authService.userID.toString();
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = "Images/$uid/$fileName";

    try {
      // Create a new storage reference pointing to the unique filePath
      await storage.ref(destination).putFile(_photo!);
      print("Successfully uploaded file $fileName");
    } catch (e) {
      print("Error occurred uploading file: $e");
    }
    setState(() {
      getAllImages();
    });
  }

  void _getDatabaseProfileType() async {
    String? uid = _authService.userID;
    DatabaseReference profileTypeRef = database.ref("Users/$uid/profileType");
    DatabaseEvent profileTypeEv = await profileTypeRef.once();
    type = profileTypeEv.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: AppTheme.colors.primary,
            elevation: 0.0,
            title: const Text('Profile Settings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if(type == "artist"){
                  Navigator.of(context).pushReplacementNamed('/account-artist');
                }
                else if(type == "venue"){
                  Navigator.of(context).pushReplacementNamed('/account-venue');
                }
              },
            )),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: AppTheme.colors.secondary,
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
          ),
          SizedBox(
            height: 32.0,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allImages.length,
              itemBuilder: (BuildContext context, int index){
                var curImage = allImages[index] != null ? Image.memory(
                  allImages[index],
                  fit: BoxFit.cover,
                ): Text(errorMsg != null ? errorMsg : "image not loading");
                return Card(
                  child: InkWell(
                      onTap: (){
                        useAsProfile(context,index);
                      },
                        child: SizedBox(
                          height: 200.0,
                          child: curImage,
                          ),
                  )
                );
              }
            )),
        ],
      ));
  }

//pop up for where to pick image from
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imageFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }


  //pop up for using an image as a profile picture
  void useAsProfile(BuildContext context, int imageIndex){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: const Text('Use as profile picture'),
                onTap: () {
                  setAsProfilePic(imageIndex);
                  Navigator.of(context).pop();
                }
              )
            ],
          ),
        );
      });
  }
}