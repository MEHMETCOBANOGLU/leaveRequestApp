
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ConversationPage extends StatefulWidget {
//   const ConversationPage(
//       {Key? key, required this.userId, required this.conversationId});

//   final String userId, conversationId;

//   @override
//   State<ConversationPage> createState() => _ConversationPageState();
// }

// class _ConversationPageState extends State<ConversationPage> {
//   final _editingControler = TextEditingController();
//   late CollectionReference _ref;
//   late FocusNode _focusNode;
//   late ScrollController _scrollController;
//   @override
//   void initState() {
//     _ref = FirebaseFirestore.instance
//         .collection('conversations/${widget.conversationId}/messages');
//     _focusNode = FocusNode(); // focusnode initalize ettme
//     _scrollController = ScrollController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _focusNode
//         .dispose(); // bu widget ekrandan kayboldugunda olusturdugumuz focusnode dispose edilerek memoryden silinecek
//     _scrollController.dispose();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           titleSpacing:
//               0, // resim/renk ile yazi arasindaki mesafeyi ayarlerken kullandik
//           title: Row(
//             children: <Widget>[
//               CircleAvatar(
//                 backgroundColor: Colors.amber,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Text("mehmet cobanglu"),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: InkWell(
//                 child: Icon(Icons.phone),
//                 onTap: () {},
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(6.0),
//               child: InkWell(
//                 child: Icon(Icons.video_camera_front_rounded),
//                 onTap: () {},
//               ),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.all(4.0),
//             //   child: InkWell(
//             //     child: Icon(Icons.more_vert),
//             //     onTap: () {},
//             //   ),
//             // ),
//           ],
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: NetworkImage("assets/Enelsis-png.png "))),
//           child: Column(children: <Widget>[
//             Expanded(
//               child: GestureDetector(
//                 //textfieldin disina tiklanidiginda klavyeyi kapatmak icin GestureDetector widget child aliyoruz
//                 onTap: () => _focusNode.unfocus(),
//                 child: StreamBuilder(
//                     stream: _ref.orderBy('timeStamp').snapshots(),
//                     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                       return !snapshot.hasData
//                           ? CircularProgressIndicator()
//                           : ListView(
//                               controller: _scrollController,
//                               children: snapshot.data!.docs
//                                   .map((document) => ListTile(
//                                         title: Align(
//                                             alignment: widget.userId !=
//                                                     document['senderId']
//                                                 ? Alignment.centerLeft
//                                                 : Alignment.centerRight,
//                                             child: Container(
//                                                 padding: EdgeInsets.all(8),
//                                                 decoration: BoxDecoration(
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                     borderRadius:
//                                                         BorderRadius.horizontal(
//                                                             left:
//                                                                 Radius.circular(
//                                                                     10),
//                                                             right:
//                                                                 Radius.circular(
//                                                                     10))),
//                                                 child: Text(
//                                                   document['message'],
//                                                   style: TextStyle(
//                                                       color: Colors.white),
//                                                 ))),
//                                       ))
//                                   .toList(),
//                             );
//                     }),
//               ),
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Container(
//                     margin: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(25),
//                         border: Border.all(color: Colors.black12)),
//                     child: Row(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: InkWell(
//                             child: Icon(
//                               Icons.tag_faces,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: TextField(
//                               focusNode: _focusNode,
//                               controller: _editingControler,
//                               decoration: InputDecoration(
//                                   hintText: "mesaj yaz...",
//                                   border: InputBorder.none)),
//                         ),
//                         InkWell(
//                           child: Icon(
//                             Icons.attach_file,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: InkWell(
//                             child: Icon(
//                               Icons.camera_alt,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(right: 5),
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).primaryColor),
//                   child: IconButton(
//                       icon: Icon(Icons.send),
//                       color: Colors.white,
//                       onPressed: () async {
//                         await _ref.add({
//                           'senderId': widget.userId,
//                           'message': _editingControler.text,
//                           'timeStamp': DateTime.now()
//                         });
//                         //animeto daki ofset listenin basindan mi sonundan mi olmasini saglar
//                         //bizde mesajlar surekli yenilendigi icin listenin en sonu _scrollController.position.maxScrollExtent, oluyor
//                         _scrollController.animateTo(
//                             _scrollController.position.maxScrollExtent,
//                             duration: Duration(microseconds: 200),
//                             curve: Curves.easeIn);
//                         _editingControler.text = "";
//                       }),
//                 )
//               ],
//             ),
//           ]),
//         ));
//   }
// }
