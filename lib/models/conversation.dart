import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:whatsapp_clone/models/profile.dart';

class Conversation {
  String id;
  String username;
  String profileImage;
  String displayMessage;

  Conversation(
      {required this.id,
      required this.username,
      required this.profileImage,
      required this.displayMessage});
  // 9.dk

  factory Conversation.fromSnapshot(DocumentSnapshot snapshot) {
    final data =
        snapshot.data() as Map<String, dynamic>; // Call data() to get the map

    return Conversation(
      id: snapshot.id,
      username: 'dali',
      profileImage: 'assets/Enelsis-png.png',
      displayMessage:
          data["displayMessage"] as String, // Access the field from the map
    );
  }

  // factory Conversation.fromSnapshot(
  //     DocumentSnapshot snapshot, Profile otherUser) {
  //   return Conversation(
  //     snapshot.id,
  //     otherUser.userName,
  //     otherUser.profileImage,
  //     snapshot.data()['displayMessage'],
  //   );
  // }
}
