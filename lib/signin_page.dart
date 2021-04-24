import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:very_good_notes/all_notes/all_notes_page.dart';
import 'package:very_good_notes/resources/resources.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In page'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.sticky_note_2_outlined,
                  size: 150,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(height: 24),
                // const Padding(
                //   padding: EdgeInsets.all(16.0),
                //   child: Text('OR'),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   child: Text(
                //     'Sign in with email and password',
                //     style: Theme.of(context).textTheme.headline6,
                //   ),
                // ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', hintText: 'Enter your Email Address'),
                  validator: (String? value) {
                    if (value?.isEmpty ?? false)
                      return 'Please enter some text';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Password', hintText: 'Enter your Password'),
                  validator: (String? value) {
                    if (value?.isEmpty ?? false)
                      return 'Please enter some text';
                    return null;
                  },
                  obscureText: true,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: const Text('Sign Up'),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          var user = await _createUserWithEmailAndPassword();
                          if (user != null) {
                            var route = MaterialPageRoute(
                              builder: (context) {
                                return AllNotesPage();
                              },
                            );
                            await Navigator.of(context).push(route);
                          }
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      // Buttons.Email,
                      child: const Text('Sign In'),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          var user = await _signInWithEmailAndPassword();
                          if (user != null) {
                            var route = MaterialPageRoute(
                              builder: (context) {
                                return AllNotesPage();
                              },
                            );
                            await Navigator.of(context).push(route);
                          }
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Or',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.black38),
                  ),
                ),
                SignInButton(
                  Buttons.Google,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<User?> _createUserWithEmailAndPassword() async {
    try {
      var userCredential = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text))
          .user;
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  // Example code of how to sign in with email and password.
  Future<User?> _signInWithEmailAndPassword() async {
    try {
      final user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user?.email} signed in'),
        ),
      );
      return user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
        ),
      );
    }
  }
}
