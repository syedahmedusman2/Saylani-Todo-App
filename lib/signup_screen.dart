import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseclass1/homescreen.dart';
import 'package:firebaseclass1/signin_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  signup(context) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((val) {
        FirebaseFirestore.instance
            .collection('userdata')
            .doc(val.user!.uid)
            .set({
          'email': emailController.text,
          'age': ageController.text,
          'name': nameController.text
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomeScreen()));
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(label: Text("Email")),
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(label: Text("Password")),
          ),
          TextFormField(
            controller: ageController,
            decoration: InputDecoration(label: Text("age")),
          ),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(label: Text("name")),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SignInScreen()));
            },
            child: Text("Already have an account? SignIn"),
          ),
          ElevatedButton(
              onPressed: () {
                signup(context);
              },
              child: Text("Signup"))
        ],
      ),
    );
  }
}
