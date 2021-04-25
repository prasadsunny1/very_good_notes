import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:very_good_notes/create_notes/create_notes_page.dart';
import 'package:very_good_notes/signin_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AllNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Very Good Notes'),
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
              return const CreateNotesPage();
            },
          );

          Navigator.of(context).push(route);
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        child: UserInformation(),
      ),
    );
  }
}

class UserInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notes = FirebaseFirestore.instance.collection('notes');

    return StreamBuilder<QuerySnapshot>(
      stream: notes.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return StaggeredGridView.countBuilder(
          primary: false,
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          padding: const EdgeInsets.all(8),
          itemCount: snapshot.data?.size ?? 0,
          itemBuilder: (context, index) {
            var document = snapshot.data?.docs[index];
            return NoteTile(
              title: document?.data()['title'] ?? '',
              body: document?.data()['note'] ?? '',
              documentRefId: document?.id,
              onPressed: (documentRefId) {
                // open the edit page with the doc ref
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateNotesPage(documentId: document?.id);
                    },
                  ),
                );
              },
            );
          },
          staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        );
      },
    );
  }
}

class NoteTile extends StatelessWidget {
  const NoteTile(
      {Key? key,
      this.title,
      this.body,
      this.documentRefId,
      required this.onPressed})
      : super(key: key);

  final String? title;
  final String? body;
  final String? documentRefId;
  final Function(String documentRefId) onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (documentRefId != null) {
          onPressed(documentRefId!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black45,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title ?? '',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                body ?? '',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
