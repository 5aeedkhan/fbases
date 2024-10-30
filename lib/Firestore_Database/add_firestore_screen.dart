import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbases/Widgets/round_button.dart';
import 'package:fbases/utils/utils.dart';
import 'package:flutter/material.dart';

class AddFirestoreScreen extends StatefulWidget {
  const AddFirestoreScreen({super.key});

  @override
  State<AddFirestoreScreen> createState() => _AddFirestoreScreenState();
}

class _AddFirestoreScreenState extends State<AddFirestoreScreen> {
  bool loading = false;
  TextEditingController postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add FireStore Data',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: const InputDecoration(
                    hintText: 'What is in your mind',
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 40,
              ),
              RoundButton(
                  loading: loading,
                  title: 'ADD',
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    fireStore.doc(id).set({
                      'title': postController.text.toString(),
                      'id': id
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage('Post Added');
                    }).onError((error, StackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
