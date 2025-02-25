import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.black,
        title: Text("CRUD Firebase"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.readNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List notes = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = notes[index];
                final String docID = document.id;
                final Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                final String note = data["note"];
                return ListTile(
                  title: Text(note),
                  trailing: IconButton(
                    onPressed: () {
                      firestoreService.deleteNote(docID);
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("There are no notes yet."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: LinearBorder(),
        onPressed: openDialog,
        child: Icon(Icons.add, size: 30.0, color: Colors.white),
      ),
    );
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: LinearBorder(),
          title: Text("Add some data:"),
          content: TextField(controller: _controller),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _controller.clear();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                firestoreService.addNote(_controller.text);
                _controller.clear();
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
