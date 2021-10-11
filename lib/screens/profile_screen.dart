import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        body: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                child: Stack(
                  children: [
                    ClipOval(
                      child: Image.network(
                        userModel == null
                            ? placeholderImage
                            : userModel!.profileImage == ''
                                ? placeholderImage
                                : userModel!.profileImage,
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                            shape: BoxShape.circle),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.red,
                            ),
                            onPressed: () {

                              // select and upload image to firebase storage


                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Joined'),
                          Text(
                            userModel != null
                                ? getHumanReadableDate(userModel!.dt)
                                : '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email'),
                          Text(
                            userModel != null ? '${userModel!.email}' : '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Full Name'),
                          Text(
                            userModel != null ? '${userModel!.name}' : '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          print('Show Dialog');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd-MMM-yyy').format(dateTime);
  }
}
