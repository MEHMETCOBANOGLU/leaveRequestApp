import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/messaging/messages.dart';
import 'package:enelsis_app/messaging/new_messages.dart';
//import 'package:enelsis_app/messaging/auth_screen.dart';
import 'package:flutter/material.dart';
//import 'enter_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sabitler/ext.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final String receivedName;
  var roomID;
  Color appBar = Color(0xff125589);
  Color back = Color(0xffffffff);

  // void logout() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.remove('token');
  //   FirebaseAuth.instance.signOut();
  //   print('logout');
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AuthScreen()),
  //   );
  // }

  // void room() async {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => JoinRoom()),
  //   );
  // }

  void getRoomID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      roomID = pref.getString('room');
    });
    print(roomID);
  }

  @override
  void initState() {
    getRoomID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser;
    final _firestore = FirebaseFirestore.instance;

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    print(arguments['name']);

    return Scaffold(
      backgroundColor: back,
      appBar: AppBar(
        backgroundColor: renk(laci),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // print(receivedName);
            // print(receivedName);
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

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person),
                Text(name, style: TextStyle(fontSize: 18)),
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
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              print(arguments);
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}
