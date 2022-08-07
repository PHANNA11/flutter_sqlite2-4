import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqlite1/Model/user_model.dart';
import 'package:sqlite1/View/update.dart';
import 'package:sqlite1/connection/database_connection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  late DatabaseConnection db;
  Future<List<User>>? listUser;
  // Future<List<User>> getList() async {
  //   return await db.getUser();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseConnection();
    db.initializeUserDB().whenComplete(() async {
      setState(() {
        listUser = db.getUser();
        print(listUser!.then((value) => value.first.name.toString()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  hintText: 'Enter name', border: OutlineInputBorder()),
            ),
          ),
          Container(
              height: 400,
              width: double.infinity,
              child: FutureBuilder(
                future: listUser,
                builder: (context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  //  else if (snapshot.hasError) {
                  //   return Center(
                  //     child: Icon(
                  //       Icons.info,
                  //       color: Colors.red,
                  //       size: 28,
                  //     ),
                  //   );
                  // } else {
                  //   var item = snapshot.data ?? <User>[];
                  //   ListView.builder(
                  //     itemCount: item.length,
                  //     itemBuilder: (context, index) {
                  //       return ListTile(
                  //         title: Text(item[index].name),
                  //       );
                  //     },
                  //   );
                  // }
                  return snapshot.hasError
                      ? const Center(
                          child: Icon(
                            Icons.info,
                            color: Colors.red,
                            size: 28,
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateScreen(user: item),
                                    ));
                              },
                              onLongPress: () async {
                                await DatabaseConnection()
                                    .deleteuser(item.id)
                                    .whenComplete(() {
                                  setState(() {
                                    print('Delete success');
                                  });
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(item.id.toString()),
                                  ),
                                  title: Text(item.name),
                                ),
                              ),
                            );
                          },
                        );
                },
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DatabaseConnection()
              .insetUser(User(id: Random().nextInt(200), name: controller.text))
              .whenComplete(() {
            print('insert succes');
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.done),
      ),
    );
  }
}
