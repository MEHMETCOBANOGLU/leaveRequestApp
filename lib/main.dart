import 'package:enelsis_app/messaging/chat_page.dart';
import 'package:enelsis_app/sayfalar/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'sabitler/activationForm.dart';
import 'sayfalar/admin_page.dart';
import 'sayfalar/izinler_page.dart';
import 'sayfalar/oturum/giris.dart';
import 'firebase_options.dart';
import 'sayfalar/sign_up.dart';
import 'sayfalar/usersActivation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        "/loginPage": (context) => GirisSayfasi(),
        "/signUp": (context) => SignUp(),
        "/homePage": (context) => HomePage(),
        "/izinlerSayfasi": (context) => IzinlerSayfasi(),
        "/adminPage": (context) => adminPage(),
        "/chatPage": (context) => ChatScreen(),
        "/usersActivation": (context) => UsersActivation(),
        "/activationForm": (context) => ActivationForm(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: GirisSayfasi(),
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
