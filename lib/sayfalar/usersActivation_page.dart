import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/sabitler/activationCard.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersActivation extends StatefulWidget {
  const UsersActivation({super.key});

  @override
  State<UsersActivation> createState() => _UsersActivationState();
}

class _UsersActivationState extends State<UsersActivation> {
  final _firestore = FirebaseFirestore.instance;

  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Çıkış işlemi burada yapılabilir
            Navigator.pop(context); // Geri dön
          },
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection('users').doc(_currentUser!.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text(
                  'Veri yüklenirken bir hata oluştu: ${snapshot.error}');
            }

            final userData =
                snapshot.data?.data() as Map<String, dynamic>? ?? {};
            final String name = userData['name'] as String? ?? '';
            final String department = userData['department'] as String? ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 18)),
                Text(department, style: TextStyle(fontSize: 14)),
              ],
            );
          },
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
                  if (username.isEmpty) {
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
                          arguments: userId);
                    },
                    onReject: () {},
                  );
                }
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.add_task_outlined),
              onPressed: () {
                Navigator.pushNamed(context, '/adminPage');
              },
            ),
            label: 'İzinler',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person_add_alt_1),
              onPressed: () {
                Navigator.pushNamed(context, '/usersActivation');
              },
            ),
            label: 'Kullanıcı Aktivasyon',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.pushNamed(context, '/chatDm');
              },
            ),
            label: 'Mesaj ',
          ),
        ],
        // selectedItemColor: Colors.blue,
      ),
    );
  }
}