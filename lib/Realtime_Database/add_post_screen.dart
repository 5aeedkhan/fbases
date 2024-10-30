import 'package:fbases/Widgets/round_button.dart';
import 'package:fbases/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  final _addTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD POST'),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                maxLines: 4,
                controller: _addTextController,
                decoration: const InputDecoration(
                  hintText: 'What is in your mind',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              RoundButton(
                  loading: loading,
                  title: 'Add',
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    final id = DateTime.now().microsecondsSinceEpoch.toString();
                    databaseRef.child(id).set({
                      'title': _addTextController.text.toString(),
                      'id': id,
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage('Post Added');
                    }).onError(
                      (error, stackTrace) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
