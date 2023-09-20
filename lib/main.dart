import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/pages/admin_page.dart';
import 'package:enelsis_app/pages/aktivationLogin.dart';
import 'package:enelsis_app/pages/home_page.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sabitler/myRouters.dart';
import 'package:enelsis_app/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool _isSignedIn = false;
    String rool = "";
    final firebaseAuth = FirebaseAuth.instance;
     AuthService authService = AuthService();
  @override
  void initState() {
    getUserLoggedInStatus();
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
    getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) =>
                AuthService(), 
          ),
          StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null,
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: MyRoutes.genrateRoute,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: renk(laci)),
            useMaterial3: true,
          ),
          home: 
              _isSignedIn ?  rool == "Admin" ?  const adminPage() : const HomePage() :  const AktivationLogin(), 
        ),
      ),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
