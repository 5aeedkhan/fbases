import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbases/utils/utils.dart';
import 'package:flutter/material.dart';

import 'add_firestore_screen.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final firestorescreen =
      FirebaseFirestore.instance.collection('users').snapshots();
  TextEditingController searchController = TextEditingController();
  TextEditingController editingController = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FIRESTORE',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: firestorescreen,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (ConnectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) return const Text('Error');
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text(
                        'No data available'); // handle empty or null data
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var document = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(
                              snapshot.data!.docs[index]['title'].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index].id.toString()),
                          trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showMyDialog(
                                              document['title'], document.id);
                                        },
                                        leading: const Icon(Icons.edit),
                                        title: const Text('UPDATE'),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          ref
                                              .doc(snapshot
                                                  .data!.docs[index]['id']
                                                  .toString())
                                              .delete();
                                        },
                                        leading: const Icon(Icons.delete),
                                        title: const Text('DELETE'),
                                      ),
                                    ),
                                  ]),
                        );
                      });
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddFirestoreScreen()));
          }),
    );
  }

  Future<void> showMyDialog(String title, String id) {
    editingController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('UPDATE'),
            content: Container(
              child: TextFormField(
                controller: editingController,
                decoration: const InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.doc(id).update({
                    'title': editingController.text.toLowerCase(),
                  }).then((value) {
                    Utils().toastMessage('POST UPDATED');
                  }).onError((error, StackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: const Text('UPDATE'),
              ),
            ],
          );
        });
  }
}
