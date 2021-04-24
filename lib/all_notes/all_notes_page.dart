import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:very_good_notes/create_notes/create_notes_page.dart';
import 'package:very_good_notes/signin_page.dart';

class AllNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn.standard().signOut();
                await Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (ctx) => SignInPage()));
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var route = MaterialPageRoute(
            builder: (context) {
              return CreateNotesPage();
            },
          );

          Navigator.of(context).push(route);
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        child: ListView(
          children: [
            const ListTile(
              title: Text('Title'),
              subtitle: Text('Subtitle'),
              tileColor: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }
}
