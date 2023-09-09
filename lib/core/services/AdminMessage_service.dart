// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:enelsis_app/models/conversation.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// final _firestore = FirebaseFirestore.instance;

// class AdminMessageService {
//   Future<Conversation> startConversation(User user, profile) async {
//     var ref = _firestore.collection('conversation');

//     var documentRef = await ref.add({
//       'displayMessage': '',
//       'members': [user.uid, profile.id]
//     });

//     return Conversation(
//         id: documentRef.id,
//         userName: profile.userName,
//         profileImage: profile.image,
//         displayMessage: '');
//   }

// //   final _firestore = FirebaseFirestore.instance;
// }
