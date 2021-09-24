import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/models/task_model.dart';
import 'package:todo_firebase/screens/add_task_screen.dart';
import 'package:todo_firebase/screens/login_screen.dart';
import 'package:todo_firebase/screens/profile_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  User? user;
  DatabaseReference? taskRef;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      taskRef =
          FirebaseDatabase.instance.reference().child('tasks').child(user!.uid);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Tasks List'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ProfileScreen();
                }));
              },
              icon: Icon(Icons.person)),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddTaskScreen();
          }));
        },
      ),
      body: StreamBuilder(
        stream: taskRef != null ? taskRef!.onValue : null,
        builder: (context, snap) {
          if (snap.hasData && !snap.hasError) {
            var event = snap.data as Event;

            var snshot = event.snapshot.value;

            Map<String, dynamic> map = Map<String, dynamic>.from(snshot);
            print(map.toString());
            var tasks = <TaskModel>[];

            for (var taskMap in map.values) {
              tasks.add(TaskModel.fromMap(Map<String, dynamic>.from(taskMap)));
            }
            print(tasks.length);

            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  TaskModel taskModel = tasks[index];

                  return Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white54,
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(taskModel.taskName),
                            Text(getHumanReadableDate( taskModel.dt))
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.delete)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.edit)),
                          ],
                        ),
                      )
                    ]),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  String getHumanReadableDate( int dt ){

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd/MM/yyyy').format(dateTime);

    //return '';
  }
}
