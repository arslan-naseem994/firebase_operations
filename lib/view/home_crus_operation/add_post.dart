import 'package:firebase_database/firebase_database.dart';
import 'package:firebases/utils/utils.dart';
import 'package:firebases/utils/widgets/round_button.dart';
import 'package:firebases/view/home_crus_operation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final dbref = FirebaseDatabase.instance.ref('post');
  bool loading = false;
  TextEditingController addpost = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('AddPost'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
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
                dbref.child(id).set({
                  'id': id,
                  'subtitle': addpost.text.toString(),
                }).then((value) {
                  Utils.toastMessage(context, 'Post Added Successfully');
                  setState(() {
                    loading = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const HomeScreen())));
                }).onError((error, stackTrace) {
                  setState(() {
                    Utils.toastMessage(context, error.toString());
                    loading = false;
                  });
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
