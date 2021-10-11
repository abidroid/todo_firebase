import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  bool showLocalImage = false;

  final placeholderImage =
      'https://via.placeholder.com/300.png/000000/FFFFFF/?text=Not Selected';

  UserModel? userModel;
  User? user;
  DatabaseReference? userRef;

  _getUserDetails() async {
    if (userRef != null) {
      userRef!.once().then((dataSnapshot) {
        print(dataSnapshot.value.toString());

        userModel =
            UserModel.fromJson(Map<String, dynamic>.from(dataSnapshot.value));
        setState(() {});
      });
    }
  }

  _pickImageGallery() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;

    final tempImage = File(xFile.path);
    image = tempImage;
    showLocalImage = true;
    setState(() {});
  }

  _pickImageCamera() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if( xFile == null) return;

    final tempImage = File(xFile.path);
    image = tempImage;
    showLocalImage = true;
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef =
          FirebaseDatabase.instance.reference().child('users').child(user!.uid);
    }
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: userModel == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    child: Stack(
                      children: [
                        ClipOval(
                          child: showLocalImage == true
                              ? Image.file(
                                  image!,
                                  width: 120,
                                  height: 120,
                            fit: BoxFit.fill,
                                )
                              : Image.network(
                                  userModel!.profileImage == ''
                                      ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnme6H9VJy3qLGvuHRIX8IK4jRpjo_xUWlTw&usqp=CAU'
                                      : userModel!.profileImage,
                                  width: 120,
                                  height: 120,
                            fit: BoxFit.fill,
                                ),
                        ),
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: Icon(Icons.image),
                                            title: Text('Gallery'),
                                            onTap: () {
                                              _pickImageGallery();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.camera_alt),
                                            title: Text('Camera'),
                                            onTap: () {
                                              _pickImageCamera();
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: Icon(Icons.camera_alt),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Member Since: ${getHumanReadableDate(userModel!.dt)}'),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('FullName ${userModel!.name}'),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            Text('Email: ${userModel!.email}'),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd-MMM-yyy').format(dateTime);
  }
}
