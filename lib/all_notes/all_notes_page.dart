import 'package:flutter/material.dart';
import 'package:very_good_notes/create_notes/create_notes_page.dart';

class AllNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var route = MaterialPageRoute(
            builder: (context) {
              return CreateNotesPage();
            },
          );

          Navigator.of(context).push(route);
          // showModalBottomSheet(
          //   context: context,
          //   builder: (context) {
          //     return Dialog(
          //       insetPadding: const EdgeInsets.only(left: 16, right: 16),
          //       elevation: 0,
          //       child: Column(
          //         children: [
          //           TextField(
          //             controller: TextEditingController(),
          //             decoration: const InputDecoration(
          //               border: InputBorder.none,
          //               hintText: 'Write a title',
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // );
// ScaffoldMessenger. of(context).
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
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
