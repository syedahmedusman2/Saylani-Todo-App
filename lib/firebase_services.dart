import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference todo = FirebaseFirestore.instance.collection('todo');

  Future<void> addUser({task, context}) {
    // Call the user's CollectionReference to add a new user
    return todo
        .add({'task': "${task}", "createdAt": DateTime.now()}).then((value) {
      Navigator.pop(context);
    }).catchError((error) => print("Failed to add user: $error"));
  }

  updateTodo({task, context, docId}) {
    // Call the user's CollectionReference to add a new user
    print(task);
    todo.doc(docId).update({'task': "${task}"}).then((value) {
      Navigator.pop(context);
    }).catchError((error) => print("Failed to add user: $error"));
  }


  deleteTodo(docName) {
    todo.doc(docName).delete();
    print("Delete Is Successful");
  }
}
