import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/model/pushnotification_model.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sabitler/notification_badge.dart';
import 'package:enelsis_app/sabitler/theme.dart';
import 'package:enelsis_app/pages/sign_up.dart';
import 'package:enelsis_app/service/auth_service.dart';
import 'package:enelsis_app/service/database_service.dart';
import 'package:enelsis_app/widgets/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

class AktivationLogin extends StatefulWidget {
  const AktivationLogin({super.key});

  @override
  State<AktivationLogin> createState() => _AktivationLoginState();
}

class _AktivationLoginState extends State<AktivationLogin> {
  Tema tema = Tema();
  bool sifre_gozukme = false;

  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  bool userIsAdmin = false; 
  bool _isLoading = false;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late  String name = "";

  late final FirebaseMessaging _messaging;
  late int _totalNotificationCounter;
  // model
  PushNotification? _notificationInfo;

  // register notification
  void registerNotification() async {
    await Firebase.initializeApp();
    //instance for firebase messaging
    _messaging = FirebaseMessaging.instance;

    //three type of state in notification
    //not determined (null), granted(ture) and decline(false)

    NotificationSettings settings = await _messaging.requestPermission(
        alert: true, sound: true, badge: true, provisional: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted the permissioin');
      // main message

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
        setState(() {
          _totalNotificationCounter++;
          _notificationInfo = notification;
        });

        if (notification != null) {
          showSimpleNotification(Text(_notificationInfo!.title!),
              leading: NotificationBadege(
                  totalNotification: _totalNotificationCounter), /////////////
              subtitle: Text(_notificationInfo!.body!),
              background: Colors.cyan.shade700,
              duration: Duration(seconds: 2));
        }
      });
    } else {
      print('permission declined by user');
    }
  }

  AuthService authService = AuthService();

   
   
   //check the initial messae that we recive
   checkForInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null ) {

          PushNotification notification = PushNotification(
          title: initialMessage.notification!.title,
          body: initialMessage.notification!.body,
          dataTitle: initialMessage.data['title'],
          dataBody: initialMessage.data['body'],
        );
        setState(() {
          _totalNotificationCounter++;
          _notificationInfo = notification;
        });
      
    }
   }



  @override
  void initState() {
     //uygulama kapiyken bildirim gelmesini sagliyor   // when app is background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
              PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
        setState(() {
          _totalNotificationCounter++;
          _notificationInfo = notification;
        });


    });
    // normal notification
    registerNotification();
    // when app is terminated state
    checkForInitialMessage();
    _totalNotificationCounter = 0;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              )
            : ListView(
                children: [
                      Container(
                      width:double.infinity,
                      decoration: BoxDecoration(color: renk(arka_renk)),
                      child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 3, bottom: 0),
                              child: SizedBox(
                                height: 200,
                                width: 800,
                                child: Image.asset("assets/enelsis_logo2.png"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              decoration: tema
                                  .inputBoxDec(),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 5, bottom: 5),
                              child: TextFormField(
                                controller: usernameController,

                                decoration: tema.inputDec(
                                    "Kullanıcı Adınızı Giriniz",
                                    Icons
                                        .people_alt_outlined), 
                                style: GoogleFonts.quicksand(
                                  color: renk(metin_renk),
                                ),
                                //    onSaved: (value) {
                                //    name = value!;
                                //  },
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9](_(?!(\.|_))|\.(?!(_|\.))|[a-zA-Z0-9]){0,18}[a-zA-Z0-9]$")
                                          .hasMatch(val!)
                                      ? null
                                      : "Lütfen geçerli bir kullanıcı adı giriniz..";
                                },
                              ),
                            ),
                            Container(
                              decoration: tema
                                  .inputBoxDec(),  
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 15),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 5, bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: passwordController,

                                      obscureText: sifre_gozukme,
                                      decoration: tema.inputDec(
                                          "Şifre Giriniz",
                                          Icons
                                              .lock_outline), 
                                      style: GoogleFonts.quicksand(
                                        color: renk(metin_renk),
                                        letterSpacing: 3,
                                      ),
                                      validator: (val) {
                                        if (val!.length < 6) {
                                          return "Şifreniz en az 6 karakter olmalıdır";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          sifre_gozukme = !sifre_gozukme;
                                        });
                                      },
                                      icon: Icon(sifre_gozukme
                                          ? Icons.close
                                          : Icons.remove_red_eye),
                                      color: renk(metin_renk)),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final String username =
                                    usernameController.text.trim();
                                    print(username);
                                final String password =
                                    passwordController.text.trim();

                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();
                                  if (username.isEmpty) {
                                    print("username is empty");
                                  } else {
                                    if (password.isEmpty) {
                                      print("password is empty");
                                    } else {
                                      QuerySnapshot snap = await FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .where("username", isEqualTo: username)
                                          .get();
                                      if (snap.size > 0) {

                                           String email = snap.docs[0]['email'];
                                           String name = snap.docs[0]['name']; 
                                           String department = snap.docs[0]['department']; 
                                           String rool = snap.docs[0]['rool']; 
                                        
                                           await HelperFunctions.saveUserLoggedInStatus(true);
                                           await HelperFunctions.saveUserEmailSF(email);
                                           await HelperFunctions.saveUserNameSF(name);
                                           await HelperFunctions.saveUserDepartmentSF(department);
                                           await HelperFunctions.saveUserRoolDepartmentSF(rool);

                                      try {
                                        final userResult = await firebaseAuth
                                          .signInWithEmailAndPassword(
                                          email: email,
                                          password: password,
                                        );
                                        print(userResult.user!.uid);
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                      if (rool == "Admin") {
                                        Navigator.pushReplacementNamed(context, "/adminPage");
                                      } else {
                                        Navigator.pushReplacementNamed(context, "/homePage");
                                      }
                                    } else {
                                      print('Kullanıcı bulunamadı');
                                    }
                                    }
                                  }
                                }
                              },
                              
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 50,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [renk("224ABE"), renk("4E73DF")],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "Giriş Yap",
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text.rich(TextSpan(
                                text: "Hesabınız yok mu? ",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Kayıt Ol",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(context, "/signUp");
                                        }),
                                ],
                              )),
                            ),
                            SizedBox(height: 8),
                            Text.rich(TextSpan(
                              text: "Root admin girişi için ",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "tıklayın",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, "/rootAdmin");
                                      }),
                              ],
                            )),
                               // bildirim icin devam edicem bu kisma sonra
                            // SizedBox(height: 12),
                            // NotificationBadege(
                            //   totalNotification: _totalNotificationCounter,
                            // ),
                            // //if notification info is not null
                            // _notificationInfo != null
                            //     ? Column(
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: [
                            //             Text(
                            //                 'TITLE: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}',
                            //                 style: TextStyle(
                            //                     fontWeight: FontWeight.bold,
                            //                     fontSize: 16)),
                            //             SizedBox(height: 9),
                            //             Text(
                            //                 'BODY: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}',
                            //                 style: TextStyle(
                            //                     fontWeight: FontWeight.bold,
                            //                     fontSize: 16))
                            //           ])
                            //     : Container()
                          ],
                        ),
                      )),
                    ],
              ),
      ),
    );
  }
}

