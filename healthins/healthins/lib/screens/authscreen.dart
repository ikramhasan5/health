import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class authscreen extends StatefulWidget {
  const authscreen({super.key});

  @override
  State<authscreen> createState() => _authscreenState();
}

class _authscreenState extends State<authscreen> {
  final formeky = GlobalKey<FormState>();
  String username = "";
  String email = "";
  String password = "";

  bool isloginpage = false;

  beginauth() {
    final isvlaid = formeky.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isvlaid) {
      formeky.currentState!.save();
      submitTofirebase(email, username, password);
    }
  }

  submitTofirebase(String email, String username, String password) async {
    final auth = FirebaseAuth.instance;

    try {
      if (isloginpage) {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);
        print("usercredentil $userCredential");
        String uid = userCredential.user!.uid;
        print("usercredentil $uid");
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'username': username,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formeky,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isloginpage)
                TextFormField(
                  key: ValueKey("username"),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 4) {
                      return "Enter at least 4 characters";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    username = value!;
                  },
                  decoration: InputDecoration(
                    hintText: 'username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              //email
              SizedBox(
                height: 12,
              ),
              TextFormField(
                key: ValueKey("email"),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "Enter valid email";
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
                decoration: const InputDecoration(
                  hintText: "email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                key: ValueKey("password"),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return "Enter valid password";
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                },
                decoration: const InputDecoration(
                  hintText: "password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade400,
                      foregroundColor: Colors.white),
                  onPressed: beginauth,
                  child: isloginpage ? Text("login") : Text("signup"),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isloginpage = !isloginpage;
                    });
                  },
                  child: isloginpage
                      ? Text("no a member")
                      : Text("already a member?"))
            ],
          ),
        ),
      ),
    );
  }
}
