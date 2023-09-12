import 'package:enelsis_app/sayfalar/group_page.dart';
import 'package:enelsis_app/sayfalar/home_page.dart';
import 'package:enelsis_app/sayfalar/leave_page.dart';
import 'package:enelsis_app/sayfalar/profile_page.dart';
import 'package:enelsis_app/sayfalar/rootAdmin_Login.dart';
import 'package:flutter/material.dart';
import '../sayfalar/admin_page.dart';
import '../sayfalar/aktivationLogin.dart';
import '../sayfalar/usersLeaveRequest_page.dart';
import '../sayfalar/rootAdmin_page.dart';
import '../sayfalar/sign_up.dart';
import '../sayfalar/usersActivation_page.dart';
import 'activationForm.dart';

class MyRoutes {
  static Route<dynamic> genrateRoute(RouteSettings setting) {
    switch (setting.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => AktivationLogin());

      case '/homePage':
        return MaterialPageRoute(builder: (context) => HomePage());

      case '/signUp':
        return MaterialPageRoute(builder: (context) => SignUp());
      case '/rootAdmin':
        return MaterialPageRoute(builder: (context) => RootAdmin());
      case '/rootAdminPage':
        return MaterialPageRoute(builder: (context) => RootAdminPage());

      case '/usersLeaveRequest':
        return MaterialPageRoute(builder: (context) => UsersLeaveRequest());

      case '/adminPage':
        return MaterialPageRoute(builder: (context) => adminPage());
      case '/groupPage':
        return MaterialPageRoute(builder: (context) => GroupPage());

      case '/leavePage':
        return MaterialPageRoute(builder: (context) => LeavePage());
      // case '/chatPage':
      //   var d2 = setting.arguments as String;
      //   return MaterialPageRoute(builder: (context) => ChatScreen(d2));
      // case '/chatDm':
      //   return MaterialPageRoute(builder: (context) => ChatDm());

      // case '/conversationPage':
      //   return MaterialPageRoute(
      //       builder: (context) =>
      //           ConversationPage(userId: userId, conversationId: doc.id));

      case '/usersActivation':
        return MaterialPageRoute(builder: (context) => UsersActivation());

      case '/activationForm':
        var d = setting.arguments as String;
        return MaterialPageRoute(builder: (context) => ActivationForm(d));

      case '/rootAdminPage':
        return MaterialPageRoute(builder: (context) => RootAdminPage());

      // case '/aktivationLogin':
      //   return MaterialPageRoute(builder: (context) => AktivationLogin());

      // break;
      default:
    }

    return MaterialPageRoute(
        builder: (context) => Scaffold(
              body: Text("no route defined"),
            ));
  }
}
