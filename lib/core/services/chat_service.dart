// import 'dart:js_interop';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:enelsis_app/models/conversation.dart';

// class ChatService {
//   final _firestore = FirebaseFirestore.instance;

//   Stream<List<Conversation>> getConversations(String userId) {
//     var ref = _firestore
//         .collection('conversations')
//         .where('members', arrayContains: userId);
//     return ref.snapshots().map((list) => list.docs
//         .map((snapshot) => Conversation.fromSnapshot(snapshot))
//         .toList());
//   }
// }
