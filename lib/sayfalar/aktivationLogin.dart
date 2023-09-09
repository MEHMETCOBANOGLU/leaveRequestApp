import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sabitler/tema.dart';
import 'package:enelsis_app/sayfalar/sign_up.dart';
import 'package:enelsis_app/service/auth_service.dart';
import 'package:enelsis_app/service/database_service.dart';
import 'package:enelsis_app/widgets/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool userIsAdmin = false; // Varsayılan olarak kullanıcı admin değil
  bool _isLoading = false;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              )
            : SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
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
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text("İzin Alma Sistemi",
                                style: GoogleFonts.bebasNeue(
                                  color: renk(laci),
                                  fontSize: 30,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            decoration: tema
                                .inputBoxDec(), // temadan gelen box decaration
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            child: TextFormField(
                              controller: usernameController,

                              decoration: tema.inputDec(
                                  "Kullanıcı Adınızı Giriniz",
                                  Icons
                                      .people_alt_outlined), // burda tema.darttaki input giris alani yer aliyor
                              style: GoogleFonts.quicksand(
                                color: renk(metin_renk),
                              ),
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
                                .inputBoxDec(), // temadan gelen box decaration
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
                                            .lock_outline), // burda tema.darttaki input giris alani yer aliyor
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
                                      String userRole = snap.docs[0][
                                          'rool']; // 'rool' -> 'role' olarak düzeltilmiş
                                      if (userRole == "Admin") {
                                        Navigator.pushReplacementNamed(
                                            context, "/adminPage");
                                      } else {
                                        Navigator.pushReplacementNamed(
                                            context, "/homePage");
                                      }
                                    } else {
                                      print('User not found');
                                    }
                                    try {
                                      final userResult = await firebaseAuth
                                          .signInWithEmailAndPassword(
                                        email: snap.docs[0]['email'],
                                        password: password,
                                      );
                                      print(userResult.user!.uid);
                                      // context.read<AuthService>().login(
                                      //       snap.docs[0]
                                      //           ['email'], // İlk belgenin emailini alıyor
                                      //       password,
                                      //     );
                                    } catch (e) {
                                      print(e.toString());
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

                          // Container(
                          //   child: Center(
                          //     child: TextButton(
                          //       onPressed: () =>
                          //           Navigator.pushNamed(context, "/signUp"),
                          //       child: Text(
                          //         "kayıt Ol",
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                          // SizedBox(height: 1),
                          // Container(
                          //   child: Center(
                          //     child: TextButton(
                          //       onPressed: () =>
                          //           Navigator.pushNamed(context, "/rootAdmin"),
                          //       child: Text(
                          //         "ROOT ADMIN",
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    )),
              ),
      ),
    );
  }

  // login() async {
  //   if (formkey.currentState!.validate()) {
  //     formkey.currentState!.save();
  //     setState(() {
  //       _isLoading = false;
  //       email = emailController.text;
  //       username = usernameController.text;
  //       password = passwordController.text.trim();
  //     });
  //     await authService.loginWithUserNameandPassword(email, password).then(
  //       (value) async {
  //         if (value == true) {
  //           QuerySnapshot snapshot = await DatabaseService(
  //                   uid: FirebaseAuth.instance.currentUser!.uid)
  //               .gettingUserData(email);
  //           // saving the values to our shared preferences
  //           await HelperFunctions.saveUserLoggedInStatus(true);
  //           await HelperFunctions.saveUserEmailSF(email);
  //           await HelperFunctions.saveUserNameSF(snapshot.docs[0]['name']);

  //           Navigator.pushReplacementNamed(context, "/");
  //         } else {
  //           showSnackbar(context, Colors.red, value);

  //           setState(() {
  //             _isLoading = false;
  //           });
  //         }
  //       },
  //     );
  //   }
  // }
}


// Navigator.pushReplacementNamed(
//   context,
//   '/homePage',
//   arguments: email,
// );

// void route(BuildContext context) {
//   User? user = FirebaseAuth.instance.currentUser;
//   var kk = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user!.uid)
//       .get()
//       .then((DocumentSnapshot documentSnapshot) {
//     if (documentSnapshot.exists) {
//       if (documentSnapshot.get('rool') == "Admin") {
//         Navigator.pushReplacementNamed(context, "/adminPage");
//       } else {
//         Navigator.pushReplacementNamed(context, "/homePage");
//       }
//     } else {
//       print('Document does not exist on the database');
//     }
//   });
// }
