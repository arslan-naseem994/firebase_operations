import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebases/utils/utils.dart';
import 'package:firebases/view/auth/login_screen.dart';
import 'package:firebases/view/home_firestore_operations/add_firestore_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final _auth = FirebaseAuth.instance;

  final editController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () {
                _auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LoginScreen())));
                }).onError((error, stackTrace) {
                  Utils.toastMessage(context, error.toString());
                });
              },
              child: const Icon(Icons.logout_outlined)),
          const SizedBox(
            width: 10,
          )
        ],
        title: const Text('Firestore Posts Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: firestore,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Utils.toastMessage(context, 'Some Error');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return Dismissible(
                          key: Key(snapshot.data!.docs[index]['id'].toString()),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // secondaryBackground: Container(
                          //   color: Colors.red,
                          //   alignment: Alignment.centerLeft,
                          //   child: const Padding(
                          //     padding: EdgeInsets.only(left: 20.0),
                          //     child: Icon(
                          //       Icons.delete,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              // Delete code
                              ref
                                  .doc(snapshot.data!.docs[index]['id']
                                      .toString())
                                  .delete()
                                  .then((value) {
                                Utils.toastMessage(context, "Data Deleted");
                              }).onError((error, stackTrace) {
                                Utils.toastMessage(context, error.toString());
                              });
                            }
                            if (direction == DismissDirection.startToEnd) {
                              // Delete code
                              ref
                                  .doc(snapshot.data!.docs[index]['id']
                                      .toString())
                                  .delete()
                                  .then((value) {
                                Utils.toastMessage(context, "Data Deleted");
                              }).onError((error, stackTrace) {
                                Utils.toastMessage(context, error.toString());
                              });
                            }
                          },
                          child: ListTile(
                            onLongPress: () {
                              showMyDialog(
                                  snapshot.data!.docs[index]['title']
                                      .toString(),
                                  snapshot.data!.docs[index]['id'].toString());
                            },
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                          ),
                        );
                      }),
                    );
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FirestoreAddPost()));
        },
        child: const Center(child: Icon(Icons.add)),
      ),
    );
  }

  Future<void> showMyDialog(String title, String? id) async {
    if (id == null || id.isEmpty) {
      // Handle the case where id is null or empty
      Utils.toastMessage(context, "Error: Invalid ID");
      return;
    }

    editController.text = title;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Edit',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.doc(id.toString()).update(
                    {'title': editController.text.toString()}).then((value) {
                  Utils.toastMessage(context, 'Post Updated');
                }).onError((error, stackTrace) {
                  Utils.toastMessage(context, error.toString());
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
