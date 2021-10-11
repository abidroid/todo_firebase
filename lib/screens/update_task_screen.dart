import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_firebase/models/task_model.dart';

class UpdateTaskScreen extends StatefulWidget {
  final TaskModel taskModel;

  const UpdateTaskScreen({Key? key, required this.taskModel}) : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  var taskNameController = TextEditingController();

  @override
  void initState() {
    taskNameController.text = widget.taskModel.taskName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Task'),
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
                if (user != null) {
                  var taskRef = FirebaseDatabase.instance
                      .reference()
                      .child('tasks')
                      .child(user.uid);

                  await taskRef
                      .child(widget.taskModel.nodeId)
                      .update({'taskName': taskName});

                  Navigator.of(context).pop();
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
                  'UPDATE',
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
