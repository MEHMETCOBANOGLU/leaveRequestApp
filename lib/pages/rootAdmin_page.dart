import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/sabitler/activationCard.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RootAdminPage extends StatefulWidget {
  const RootAdminPage({super.key});

  @override
  State<RootAdminPage> createState() => _RootAdminPageState();
}

class _RootAdminPageState extends State<RootAdminPage> {
  final _firestore = FirebaseFirestore.instance;

  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "ROOT ADMİN AKTİVASYON",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 1),
            child: SizedBox(
              height: 200,
              width: 140,
              child: Image.asset("assets/enelsis_logo2.png"),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot userSnapshot = snapshot.data!.docs[index];

                String name = userSnapshot["name"] as String? ?? "";
                String email = userSnapshot["email"] as String? ?? "";
                String rool = userSnapshot["rool"] as String? ?? "";
                String department = userSnapshot["department"] as String? ?? "";

                // Check if "username" field exists
                if (userSnapshot.data() is Map<String, dynamic> &&
                    (userSnapshot.data() as Map<String, dynamic>)
                        .containsKey("username")) {
                  String username = userSnapshot["username"] as String;
                  if (username.isEmpty && rool == "üye") {
                    return Container(); // Username is empty, don't show card
                  } else {
                    return Container(); // Username is not empty, don't show card
                  }
                } else {
                  // "username" field doesn't exist, show the card
                  return ActivationCard(
                    name: name,
                    department: department,
                    email: email,
                    rool: rool,
                    onApprove: () {
                      String userId = userSnapshot.id;
                      Navigator.pushNamed(context, '/activationForm',
                          arguments: {'userId': userId, 'rool': rool});
                    },
                    onReject: () {
                      print(rool);
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
