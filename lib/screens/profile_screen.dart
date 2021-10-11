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
        body: userModel == null
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Container(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        userModel!.profileImage == '' ?
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnme6H9VJy3qLGvuHRIX8IK4jRpjo_xUWlTw&usqp=CAU'
                            :
                        userModel!.profileImage

                    )
                    ,
                    radius: 80,
                  ),
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: IconButton(
                      onPressed: () {},
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
                      Text('Member Since: ${getHumanReadableDate(userModel!.dt)}'),
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
