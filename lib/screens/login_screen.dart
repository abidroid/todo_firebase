import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todo_firebase/screens/signup_screen.dart';
import 'package:todo_firebase/screens/task_list_screen.dart';
import 'package:todo_firebase/widgets/CurvedClipper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordObscured = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<FirebaseApp> _initializeApp() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Column(
                    children: [
                      ClipPath(
                        clipper: CurvedClipper(),
                        child: Image(
                          image: AssetImage('assets/images/books.jpeg'),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.4,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'TODOEY',
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          letterSpacing: 2.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.account_box,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: passwordObscured,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordObscured = !passwordObscured;
                                  });
                                },
                                icon: Icon(
                                  passwordObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                )),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var email = emailController.text;
                          var password = passwordController.text;

                          var formValid = true;
                          if (email.isEmpty) {
                            Fluttertoast.showToast(msg: 'Please provide email');
                            formValid = false;
                          }

                          if (password.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Please provide password');
                            formValid = false;
                          }

                          if (formValid == false) {
                            return;
                          }

                          ProgressDialog progressDialog = ProgressDialog(
                              context, title: Text('Signing In'),
                              message: Text('Please wait'));

                          progressDialog.show();

                          FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                          try {
                            UserCredential userCredential =
                            await firebaseAuth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            progressDialog.dismiss();
                            User? user = userCredential.user;

                            if (user != null) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return TaskListScreen();
                              }));
                            }
                          } on FirebaseAuthException catch (e) {
                            progressDialog.dismiss();
                            if (e.code == 'user-not-found') {
                              Fluttertoast.showToast(msg: 'User not found');
                            } else if (e.code == 'wrong-password') {
                              Fluttertoast.showToast(msg: 'Wrong password');
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          margin: EdgeInsets.symmetric(horizontal: 50.0),
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return SignUpScreen();
                              }));
                            },
                            child: Container(
                              height: 100,
                              alignment: Alignment.center,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              child: Text(
                                'Don\'t have account, Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
