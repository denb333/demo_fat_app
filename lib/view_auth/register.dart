// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fat_app/constants/routes.dart';
// import 'package:fat_app/firebase_options.dart';
// import 'package:fat_app/ultilities/Show_Error_Dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
//
// class RegisterView extends StatefulWidget {
//   const RegisterView({Key? key}) : super(key: key);
//
//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }
//
// class _RegisterViewState extends State<RegisterView> {
//   // final _formKey = GlobalKey<FormState>();
//   final CollectionReference myItems =
//       FirebaseFirestore.instance.collection("Users");
//   late final TextEditingController _email;
//   late final TextEditingController _password;
//   late final TextEditingController _name;
//
//   @override
//   void initState() {
//     super.initState();
//     _email = TextEditingController();
//     _password = TextEditingController();
//     _name = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     _name.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register'),
//       ),
//       body: FutureBuilder(
//         future: Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform,
//         ),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Form(
//               //    key: _formKey,
//               child: ListView(
//                 padding: const EdgeInsets.all(16.0),
//                 children: [
//                   TextFormField(
//                     controller: _name,
//                     decoration: const InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _email,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!value.contains('@')) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _password,
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(),
//                     ),
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters long';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () async {
//                       //   if (_formKey.currentState!.validate()) {
//                       try {
//                         // Tạo người dùng
//                         firebase_auth.UserCredential userCredential =
//                             await firebase_auth.FirebaseAuth.instance
//                                 .createUserWithEmailAndPassword(
//                           email: _email.text,
//                           password: _password.text,
//                         );
//
//                         // Lưu thông tin người dùng vào Firestore
//                         // await FirebaseFirestore.instance
//                         //     .collection('users')
//                         //     .doc(userCredential.user!.uid)
//                         //     .set({
//                         //   'username': _name.text,
//                         //   'email': _email.text,
//                         // });
//                         // Lưu thông tin người dùng vào Firestore
//                         print(
//                             'Attempting to save user data for UID: ${userCredential.user!.uid}');
//                         try {
//                           await myItems.doc(userCredential.user!.uid).set({
//                             'username': _name.text,
//                             'email': _email.text,
//                           });
//                           print('User data saved successfully');
//                         } catch (e) {
//                           print('Error saving user data: $e');
//                         }
//                         // Điều hướng đến trang xác nhận email hoặc trang chính
//                         Navigator.of(context).pushNamed(emailverifyRoute);
//                       } catch (e) {
//                         await Show_Error_Dialog(
//                             context, 'Failed to register: ${e.toString()}');
//                       }
//                     },
//                     //    },
//                     child: const Text('Register'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                           loginRoutes, (route) => false);
//                     },
//                     child: const Text('Already registered? Login here'),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_app/service/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

// import 'model.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();
  UserService userService = new UserService();
  Color backgroughColor = Color(0xFF87B9CC);
  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  Color customColor = Color(0xC3090808);
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpassController =
  new TextEditingController();
  final TextEditingController username = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  // final TextEditingController mobile = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;

  // var _currentItemSelected = "Student";
  // var rool = "Student";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroughColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: backgroughColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        // Logo at the top
                        // SizedBox(height: 20)
                        Text(
                          'WELCOME',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Login in your create account',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Username',
                            enabled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12), // Align the icon
                              child: Icon(
                                Icons.account_circle,
                                color: customColor, // Set icon color
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 15.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Username cannot be empty";
                            }

                          },
                          onChanged: (value) {},
                          // keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            enabled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12), // Align the icon
                              child: Icon(
                                Icons.mail,
                                color: customColor, // Set icon color
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 15.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            enabled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12), // Align the icon
                              child: Icon(
                                Icons.lock,
                                color: customColor, // Set icon color
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 15.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure2,
                          controller: confirmpassController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirm Password',
                            enabled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12), // Align the icon
                              child: Icon(
                                Icons.lock,
                                color: customColor, // Set icon color
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 15.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (confirmpassController.text !=
                                passwordController.text) {
                              return "Password did not match";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        SizedBox(
                          height: 35,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                              elevation: 5.0,
                              height: 40,
                              onPressed: () {
                                setState(() {
                                  showProgress = true;
                                });
                                userService.signUp(_formkey,username.text,emailController.text,
                                    passwordController.text, context);
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              color: backgroughColor, // Set background color to green
                              width: MediaQuery.of(context).size.width,
                              height: 30, // Set the height to match the image's layout
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Already have account? ", // Non-clickable text
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Login", // Clickable text
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          // decoration: TextDecoration.underline, // Optional underline effect
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigate to the Register screen when clicked
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LoginPage(),
                                              ),
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                      ],
                    ),
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
