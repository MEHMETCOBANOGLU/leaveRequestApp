// import 'dart:html';

// import 'package:enelsis_app/models/conversation.dart';
// import 'package:enelsis_app/viewmodels/chats_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get_it/get_it.dart';
// import 'package:provider/provider.dart';

// import '../sabitler/ext.dart';
// import 'converstaion_page.dart';

// class ChatDm extends StatefulWidget {
//   const ChatDm({Key? key});

//   @override
//   State<ChatDm> createState() => _ChatDmState();
// }

// class _ChatDmState extends State<ChatDm> {
//   @override
//   Widget build(BuildContext context) {
//     var model = GetIt.instance<ChatsModel>();
//     final _currentUser = FirebaseAuth.instance.currentUser;
//     final _firestore = FirebaseFirestore.instance;
//     final String userId = "cA7cbTG4KDTR5DHqfynFBFoZOls2";
//     return ChangeNotifierProvider(
//       create: (BuildContext context) => model,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: renk(laci),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               // Çıkış işlemi burada yapılabilir
//               Navigator.pop(context); // Geri dön
//             },
//           ),
//           title: StreamBuilder<DocumentSnapshot>(
//             stream: _firestore
//                 .collection('users')
//                 .doc(_currentUser!.uid)
//                 .snapshots(),
//             builder: (BuildContext context,
//                 AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               }

//               if (snapshot.hasError) {
//                 return Text(
//                     'Veri yüklenirken bir hata oluştu: ${snapshot.error}');
//               }

//               final userData =
//                   snapshot.data?.data() as Map<String, dynamic>? ?? {};
//               final String name = userData['name'] as String? ?? '';
//               final String department = userData['department'] as String? ?? '';

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(name, style: TextStyle(fontSize: 18)),
//                   Text(department, style: TextStyle(fontSize: 14)),
//                 ],
//               );
//             },
//           ),
//           actions: [
//             Container(
//               margin: EdgeInsets.only(right: 1),
//               child: SizedBox(
//                 height: 200,
//                 width: 140,
//                 child: Image.asset("assets/enelsis_logo2.png"),
//               ),
//             ),
//           ],
//         ),
//         body: StreamBuilder<List<Conversation>>(
//           stream: model.conversations(
//               userId), // firestore instance yi silip model uzerinden conversation cagirip erisim yaptik
//           builder: (BuildContext context,
//               AsyncSnapshot<List<Conversation>> snapshot) {
//             if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Text('Loading...');
//             }
//             return ListView(
//               children: snapshot.data!
//                   .map(
//                     (doc) => ListTile(
//                       leading: CircleAvatar(
//                           backgroundColor: // eger bakcgroundimage yaparsan (doc.profileIMAGE ) KULLAN
//                               const Color.fromARGB(255, 158, 157, 157)),
//                       title: Text(doc.userName),
//                       subtitle: Text(doc.displayMessage),
//                       trailing: Column(
//                         children: [
//                           Text("19:30"),
//                           Container(
//                               width: 20,
//                               height: 20,
//                               margin: EdgeInsets.only(top: 9),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color.fromARGB(255, 115, 255, 0),
//                               ),
//                               child: Center(
//                                 child: Text("16",
//                                     textScaleFactor: 0.8,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white)),
//                               )),
//                         ],
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ConversationPage(
//                                     userId: userId, conversationId: doc.id)));
//                       },
//                     ),
//                   )
//                   .toList(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
