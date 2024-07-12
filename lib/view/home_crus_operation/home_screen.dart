import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebases/utils/utils.dart';
import 'package:firebases/view/auth/login_screen.dart';
import 'package:firebases/view/home_crus_operation/add_post.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ref = FirebaseDatabase.instance.ref('post');
  final _auth = FirebaseAuth.instance;
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  @override
  void initState() {
    // for fetching data in init state can't do this using animated list
    // animated list can be used only runtime but streambuilder can be used anywhere
    // ref.onValue.listen((event) {});
    super.initState();
  }

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
        title: const Text('HomeScreen'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Search'),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          // fetching data list using Firebase (AnimatedList)

          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: ((context, snapshot, animation, index) {
                  final title = snapshot.child('subtitle').value.toString();
                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('id').value.toString()),
                      subtitle:
                          Text(snapshot.child('subtitle').value.toString()),
                      trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 'edit',
                                    onTap: () {
                                      showMyDialog(
                                          title,
                                          snapshot
                                              .child('id')
                                              .value
                                              .toString());
                                    },
                                    child: const ListTile(
                                      title: Icon(Icons.edit),
                                      trailing: Text('Edit'),
                                    )),
                                PopupMenuItem(
                                    value: 'delete',
                                    onTap: () {
                                      ref
                                          .child(snapshot
                                              .child('id')
                                              .value
                                              .toString())
                                          .remove();
                                          Utils.toastMessage(context, 'Post Deleted ');
                                      // setState(() {});
                                    },
                                    child: const ListTile(
                                      title: Icon(Icons.delete),
                                      trailing: Text('Delete'),
                                    )),
                              ]),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(snapshot.child('id').value.toString()),
                      subtitle:
                          Text(snapshot.child('subtitle').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                })),
          ),

          // Fetching data using StreamBuilder
          // Expanded(
          //     child: StreamBuilder(
          //   stream: ref.onValue,
          //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //     if (!snapshot.hasData) {
          //       return const Center(child: CircularProgressIndicator());
          //     } else {
          //       Map<dynamic, dynamic> map =
          //           snapshot.data!.snapshot.value as dynamic;
          //       List<dynamic> list = [];
          //       list.clear();
          //       list = map.values.toList();

          //       return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: ((context, index) {
          //             return ListTile(
          //               title: Text(list[index]['id']),
          //             );
          //           }));
          //     }
          //   },
          // )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Center(child: Icon(Icons.add)),
      ),
    );
  }

  Future<void> showMyDialog(String title, String? id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    ref.child(id!).update({
                      'subtitle': editController.text.toLowerCase().toString()
                    }).then((value) {
                      Utils.toastMessage(context, 'Updated Successfullly');
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      Utils.toastMessage(context, error.toString());
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          );
        });
  }
}
