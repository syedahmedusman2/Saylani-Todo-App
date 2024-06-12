import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseclass1/homescreen.dart';
import 'package:firebaseclass1/main.dart';
import 'package:firebaseclass1/signup_screen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  login(context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((val) {
        prefs.setString('uid', val.user!.uid);
        print(prefs.getString('uid'));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomeScreen()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
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
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => MainScreen()));
            },
            child: Text("Create New Account"),
          ),
          ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: Text("Sign In"))
        ],
      ),
    );
  }
}
