import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateNotesPage extends StatefulWidget {
  final String? documentId;

  const CreateNotesPage({Key? key, this.documentId}) : super(key: key);
  @override
  _CreateNotesPageState createState() => _CreateNotesPageState();
}

class _CreateNotesPageState extends State<CreateNotesPage> {
  final titleTextEditingController = TextEditingController();
  final noteTextEditingController = TextEditingController();
  final fireStore = FirebaseFirestore.instance;

  String currentNoteDocRef = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var title = titleTextEditingController.text;
        var note = noteTextEditingController.text;
        await _addOrUpdateNote(title, note);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextField(
                controller: titleTextEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  // _addOrUpdateNote(value, '');
                },
              ),
              TextField(
                controller: noteTextEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note',
                ),
                onChanged: (value) {
                  // _addOrUpdateNote('', value);
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.documentId != null && widget.documentId!.isNotEmpty) {
      currentNoteDocRef = widget.documentId!;

      FirebaseFirestore.instance
          .collection('notes')
          .doc(currentNoteDocRef)
          .get()
          .then((doc) {
        titleTextEditingController.text = doc.data()?['title'] ?? '';
        noteTextEditingController.text = doc.data()?['note'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // get values and store to firebase
    //
  }

  Future<bool?> _addOrUpdateNote(String title, String note) async {
    var mapToUpdate = <String, dynamic>{'title': title, 'note': note};
    var isAllEmpty = mapToUpdate.values
        .cast<String>()
        .every((String element) => element.isEmpty);
    if (isAllEmpty) {
      var shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Delete the note?'),
            children: [
              SimpleDialogOption(
                child: ElevatedButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
              SimpleDialogOption(
                child: ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
            ],
          );
        },
      );
      if (shouldDelete != null &&
          shouldDelete &&
          currentNoteDocRef.isNotEmpty) {
        await fireStore.collection('notes').doc(currentNoteDocRef).delete();
      }
      return false;
    }
    if (currentNoteDocRef.isNotEmpty) {
      // Update the existing Doc
      await fireStore
          .collection('notes')
          .doc(currentNoteDocRef)
          .update(mapToUpdate)
          .onError((error, stackTrace) {
        log(error.toString(), stackTrace: stackTrace);
      });
    } else {
      // create a new note
      print('Create a new note');
      var docRef = await fireStore.collection('notes').add(mapToUpdate);
      currentNoteDocRef = docRef.id;
    }
    return true;
  }
}
