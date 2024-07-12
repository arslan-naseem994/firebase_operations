import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebases/utils/utils.dart';
import 'package:firebases/utils/widgets/round_button.dart';
import 'package:firebases/view/home_firestore_operations/firestore_list_screen.dart';
import 'package:flutter/material.dart';

class FirestoreAddPost extends StatefulWidget {
  const FirestoreAddPost({super.key});

  @override
  State<FirestoreAddPost> createState() => _FirestoreAddPostState();
}

class _FirestoreAddPostState extends State<FirestoreAddPost> {
  bool loading = false;
  TextEditingController addpost = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final firestore = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Firestore AddPost'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              focusNode: _focusNode,
              maxLines: 4,
              controller: addpost,
              decoration: InputDecoration(
                hintText: "What's in your mind?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              ontap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                firestore.doc(id).set({
                  'id': id,
                  'title': addpost.text.toString(),
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const FirestoreScreen())));
                  Utils.toastMessage(context, 'Post Added Successfully');
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils.toastMessage(context, error.toString());
                });
              },
              loading: loading,
              title: 'AddPost',
            )
          ],
        ),
      ),
    );
  }
}
