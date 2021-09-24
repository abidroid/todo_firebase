import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var taskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(
                hintText: 'Task Name',
                prefixIcon: Icon(Icons.add_comment),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                var taskName = taskNameController.text;
                if (taskName.isEmpty) {
                  Fluttertoast.showToast(msg: 'Please provide task name');
                  return;
                }

                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  return;
                }

                var databaseRef = FirebaseDatabase.instance.reference();

                String key =
                    databaseRef.child('tasks').child(user.uid).push().key;

                try{
                  await databaseRef
                      .child('tasks')
                      .child(user.uid)
                      .child(key)
                      .set({
                    'nodeId' : key,
                    'taskName': taskName,
                    'dt': DateTime.now().millisecondsSinceEpoch,

                  });

                  Fluttertoast.showToast(msg: 'Task Added');

                } catch (e ){
                  Fluttertoast.showToast(msg: 'Something went wrong');
                }

              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                margin: EdgeInsets.symmetric(horizontal: 50.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'SAVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
