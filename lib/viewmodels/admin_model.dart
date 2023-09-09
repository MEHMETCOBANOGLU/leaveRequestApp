// import 'dart:js';

// import 'package:enelsis_app/core/services/AdminMessage_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';

// import '../messaging/converstaion_page.dart';
// import 'base_model.dart';

// class AdminMessageModel extends BaseModel {
//   final AdminMessageService _adminMessageService =
//       GetIt.instance<AdminMessageService>();

//   Future<startConversation>(User user, profile) async {
//     var conversation =
//         await _adminMessageService.startConversation(user, profile);
//     return MaterialPageRoute(
//         builder: (context) => ConversationPage(
//             conversationId: conversation.id, userId: user.uid));
//   }
// }
