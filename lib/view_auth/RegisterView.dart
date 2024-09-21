import 'package:fat_app/auth/auth_service.dart';
import 'package:fat_app/constants/routes.dart';
import 'package:fat_app/firebase_options.dart';
import 'package:fat_app/ultilities/Show_Error_Dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await AuthServices.firebase().createUser(
                              email: _email.text, password: _password.text);

                          // Update the user's display name
                          firebase_auth.User? firebaseUser =
                              firebase_auth.FirebaseAuth.instance.currentUser;
                          if (firebaseUser != null) {
                            await firebaseUser.updateDisplayName(_name.text);
                          }

                          await AuthServices.firebase()
                              .sendEmailVertification();
                          Navigator.of(context).pushNamed(emailverifyRoute);
                          Navigator.of(context).pushNamed(emailverifyRoute);
                        } catch (e) {
                          await Show_Error_Dialog(
                              context, 'Failed to register: ${e.toString()}');
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoutes, (route) => false);
                    },
                    child: const Text('Already registered? Login here'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
