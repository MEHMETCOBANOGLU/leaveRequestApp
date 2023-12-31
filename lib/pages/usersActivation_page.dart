import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
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

  String rool = "";

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  gettingUserData() async {
    await HelperFunctions.getUserRoolFromSF().then((val) {
      setState(() {
        rool = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/adminPage");
          },
        ),
        title: const Text(
          "Kullanıcı Aktivasyon",
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
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> userDocs = snapshot.data!.docs;
            List<Widget> widgets =
                []; // Widget listesini saklamak için bir liste

            for (int index = 0; index < userDocs.length; index++) {
              DocumentSnapshot userSnapshot = userDocs[index];

              String name = userSnapshot["name"] as String? ?? "";
              String email = userSnapshot["email"] as String? ?? "";
              String rool = userSnapshot["rool"] as String? ?? "";
              String department = userSnapshot["department"] as String? ?? "";
              String uid = userSnapshot["uid"] as String? ?? "";
              Map<String, dynamic>? userData =
                  userSnapshot.data() as Map<String, dynamic>?;
              bool hasUsername = userData?.containsKey("username") ?? false;

              if ((!hasUsername) && (rool == 'Üye')) {
                // "username" alanı yoksa, ActivationCard ekleyin
                
                widgets.add(
                  ActivationCard(
                    name: name,
                    department: department,
                    email: email,
                    rool: rool,
                    onApprove: () {
                      String userId = userSnapshot.id;
                      Navigator.pushNamed(context, '/activationForm',
                          arguments: {'userId': userId, 'rool': rool});
                    },
                    onReject: () async {
                                               
                                 await  _firestore.collection('users')
                                     .doc(uid)
                                     .delete()
                            .then((_) {
                          print('Kullanıcı aktivasyonu reddedildi.');
                        }).catchError((error) {
                         
                          print(
                              'Kullanıcı aktivasyonu reddedilirken bir hata oluştu: $error');
                        });


                    },
                  ),
                );
              }
            }
            if (widgets.isEmpty) {

              widgets.add(noGroupWidget());
            }
            return ListView.builder(
              itemCount: widgets.length,
              itemBuilder: (context, index) {
                return widgets[index];
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),

      ////////////////////////////////////
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

noGroupWidget() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 250,
        ),
        Center(
          child: const Text(
            "Herhangi bir kullanıcı aktivasyonu bulunmamaktadır",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
