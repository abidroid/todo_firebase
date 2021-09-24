import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:todo_firebase/widgets/CurvedClipper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passwordObscured = true;
  bool confirmPassObscured = true;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              ClipPath(
                clipper: CurvedClipper(),
                child: Image(
                  image: AssetImage('assets/images/books.jpeg'),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'TODOEY',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    hintText: 'FullName',
                    prefixIcon: Icon(
                      Icons.account_box,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    fillColor: Colors.white,
                    filled: true,
                  ),
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
                      Icons.email,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
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
                      icon: Icon(passwordObscured
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          passwordObscured = !passwordObscured;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: TextField(
                  controller: retypePasswordController,
                  obscureText: confirmPassObscured,
                  decoration: InputDecoration(
                    hintText: 'Retype Password',
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          confirmPassObscured = !confirmPassObscured;
                        });
                      },
                      icon: Icon(confirmPassObscured
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
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
                  var formValid = true;

                  var fullName = fullNameController.text;
                  var email = emailController.text;
                  var password = passwordController.text;
                  var retypePassword = retypePasswordController.text;

                  if (fullName.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please provide FullName');
                    formValid = false;
                  }

                  if (email.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please provide email');
                    formValid = false;
                  }

                  if (password.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please provide Password');
                    formValid = false;
                  }

                  if (retypePassword.isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Please provide Retype Password');
                    formValid = false;
                  }

                  if (password.length < 6) {
                    Fluttertoast.showToast(
                        msg: 'Please provide at least 6 digits');
                    formValid = false;
                  }

                  if (password != retypePassword) {
                    Fluttertoast.showToast(msg: 'Passwords do not match');
                    formValid = false;
                  }

                  if (formValid == false) {
                    return;
                  }

                  // show progress dialog

                  //ProgressDialog progressDialog =

                  ProgressDialog progressDialog = ProgressDialog(context,
                      message: Text("Signing Up"),
                      title: Text("Please wait..."));

                  progressDialog.show();

                  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

                  try {
                    UserCredential userCredential =
                        await firebaseAuth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    User? user = userCredential.user;

                    if (user != null) {
                      // save record in realtime database
                      final databaseReference =
                          FirebaseDatabase.instance.reference();

                      await databaseReference.child('users').child(user.uid).set({
                        'uid': user.uid,
                        'name': fullName,
                        'email': email,
                        'dt': DateTime.now().millisecondsSinceEpoch,
                        'profileImage': '',
                      });

                      Fluttertoast.showToast(msg: 'Sign Up Successful');
                      progressDialog.dismiss();
                    }
                  } on FirebaseAuthException catch (e) {
                    progressDialog.dismiss();
                    if (e.code == 'weak-password') {
                      Fluttertoast.showToast(msg: 'Weak Password');
                    } else if (e.code == 'email-already-in-use') {
                      Fluttertoast.showToast(msg: 'Email Already in Use');
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'Something went wrong');
                    progressDialog.dismiss();
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
                    'SIGN UP',
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
      ),
    );
  }
}
