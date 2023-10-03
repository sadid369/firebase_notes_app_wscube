import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notes_app_wscube/models/note_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseFirestore db;
  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  var titleController = TextEditingController();
  var bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: db.collection('notes').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(
              child: Text('${snapshot.error.toString()}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var model =
                    NoteModel.fromMap(snapshot.data!.docs[index].data());
                return ListTile(
                  title: Text('${model.title}'),
                  subtitle: Text("${model.body}"),
                );
              },
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(15),
                child: Column(children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: bodyController,
                    decoration: InputDecoration(
                        hintText: "Body",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        db
                            .collection('notes')
                            .add(NoteModel(
                                    title: titleController.text.toString(),
                                    body: bodyController.text.toString())
                                .toJson())
                            .then((value) => print(value.id));
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add Notes'))
                ]),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
