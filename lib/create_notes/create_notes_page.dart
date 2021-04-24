import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
              ),
              onChanged: (value) {
                _addOrUpdateNote(value, '');
              },
            ),
            TextField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note',
              ),
              onChanged: (value) {
                _addOrUpdateNote('', value);
              },
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: () {
                      //TODO: pick and image and upload it to storage
                      //get the link and attach it to the storage
                    }),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // delete the note
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final fireStore = FirebaseFirestore.instance;
  String currentNoteDocRef = '';
  Future<void> _addOrUpdateNote(String title, String note) async {
    var mapToUpdate = <String, dynamic>{};
    if (title.isNotEmpty) {
      mapToUpdate.addAll({'title': title});
    }
    if (note.isNotEmpty) {
      mapToUpdate.addAll({'note': note});
    }

    if (currentNoteDocRef.isNotEmpty) {
      // Update the existing Doc
      await fireStore
          .collection('notes')
          .doc(currentNoteDocRef)
          .update(mapToUpdate);
    } else {
      // create a new note

      var docRef = await fireStore.collection('notes').add(mapToUpdate);
      currentNoteDocRef = docRef.id;
    }
  }
}
