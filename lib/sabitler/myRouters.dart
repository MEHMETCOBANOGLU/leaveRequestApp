import 'package:enelsis_app/pages/group_page.dart';
import 'package:enelsis_app/pages/home_page.dart';
import 'package:enelsis_app/pages/leave_page.dart';
import 'package:enelsis_app/pages/profile_page.dart';
import 'package:enelsis_app/pages/rootAdmin_Login.dart';
import 'package:flutter/material.dart';
import '../pages/admin_page.dart';
import '../pages/aktivationLogin.dart';
import '../pages/usersLeaveRequest_page.dart';
import '../pages/rootAdmin_page.dart';
import '../pages/sign_up.dart';
import '../pages/usersActivation_page.dart';
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

      case '/usersActivation':
        return MaterialPageRoute(builder: (context) => UsersActivation());

      case '/activationForm':
        var arguments = setting.arguments as Map<String, dynamic>;
        var userId = arguments['userId'] as String?;
        var rool = arguments['rool'] as String?;
        return MaterialPageRoute(
          builder: (context) => ActivationForm(userId: userId, rool: rool),
        );

      case '/rootAdminPage':
        return MaterialPageRoute(builder: (context) => RootAdminPage());


     // break;
      default:
    }

    return MaterialPageRoute(
        builder: (context) => Scaffold(
              body: Text("no route defined"),
            ));
  }
}
