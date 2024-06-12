import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseclass1/firebase_services.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({super.key});
  TextEditingController taskNameController = TextEditingController();
  FirebaseServices _services = FirebaseServices();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('todo').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo Application"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Add Task"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              controller: taskNameController,
                              decoration: InputDecoration(
                                  label: Text("Task Name"),
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _services.addUser(
                                    task: taskNameController.text,
                                    context: context);
                              },
                              child: Text("Add Todo"))
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text("${data['task']}"),
                  subtitle: Text("${data['createdAt']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            TextEditingController editTaskController =
                                TextEditingController(text: data['task']);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Edit Task"),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: TextFormField(
                                              controller: editTaskController,
                                              decoration: InputDecoration(
                                                  label: Text("Task Name"),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                _services.updateTodo(
                                                    task:
                                                        editTaskController.text,
                                                    context: context,
                                                    docId: document.id);
                                              },
                                              child: Text("Add Todo"))
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            _services.deleteTodo(document.id);
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                );
              }).toList(),
            );
          },
        )
        // ListView.builder(
        //     itemCount: 10,
        //     itemBuilder: (context, index) {
        //       return ListTile(
        //         title: Text("Task no#${index}"),
        //         subtitle: Text("6 June 2024"),
        //         trailing: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        //             IconButton(onPressed: () {}, icon: Icon(Icons.delete))
        //           ],
        //         ),
        //       );
        // }),
        );
  }
}
