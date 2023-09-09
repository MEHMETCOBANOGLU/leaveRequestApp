// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:enelsis_app/sabitler/ext.dart';
// import 'package:enelsis_app/sabitler/tema.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class GirisSayfasi extends StatefulWidget {
//   const GirisSayfasi({super.key});

//   @override
//   State<GirisSayfasi> createState() => _GirisSayfasiState();
// }

// class _GirisSayfasiState extends State<GirisSayfasi> {
//   Tema tema = Tema();
//   bool sifre_gozukme = false;

//   late String email, password;
//   final formkey = GlobalKey<FormState>();
//   final firebaseAuth = FirebaseAuth.instance;
//   bool userIsAdmin = false; // Varsayılan olarak kullanıcı admin değil

//   // final _tEmail = TextEditingController();
//   // final _tPassword = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//             width: MediaQuery.of(context).size.width,
//             // width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(color: renk(arka_renk)),
//             child: Form(
//               key: formkey,
//               child: Column(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(top: 3, bottom: 0),
//                     child: SizedBox(
//                       height: 200,
//                       width: 800,
//                       child: Image.asset("assets/enelsis_logo2.png"),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: 5, bottom: 5),
//                     child: Text("Izin Alma Sistemi",
//                         style: GoogleFonts.bebasNeue(
//                           color: renk(laci),
//                           fontSize: 30,
//                         )),
//                   ),
//                   Container(
//                     decoration:
//                         tema.inputBoxDec(), // temadan gelen box decaration
//                     margin: EdgeInsets.only(
//                         left: 10, right: 10, top: 10, bottom: 10),
//                     padding:
//                         EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
//                     child: TextFormField(
//                       onSaved: (value) {
//                         email = value!;
//                       },

//                       decoration: tema.inputDec(
//                           "E-Posta Adresinizi Giriniz",
//                           Icons
//                               .people_alt_outlined), // burda tema.darttaki input giris alani yer aliyor
//                       style: GoogleFonts.quicksand(
//                         color: renk(metin_renk),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration:
//                         tema.inputBoxDec(), // temadan gelen box decaration
//                     margin: EdgeInsets.only(
//                         left: 10, right: 10, top: 5, bottom: 15),
//                     padding: EdgeInsets.only(
//                         left: 15, right: 15, top: 5, bottom: 10),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             onSaved: (value) {
//                               password = value!;
//                             },
//                             obscureText: sifre_gozukme,
//                             decoration: tema.inputDec(
//                                 "Şifrenizi Giriniz",
//                                 Icons
//                                     .lock_outline), // burda tema.darttaki input giris alani yer aliyor
//                             style: GoogleFonts.quicksand(
//                               color: renk(metin_renk),
//                               letterSpacing: 3,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 sifre_gozukme = !sifre_gozukme;
//                               });
//                             },
//                             icon: Icon(sifre_gozukme
//                                 ? Icons.close
//                                 : Icons.remove_red_eye),
//                             color: renk(metin_renk)),
//                       ],
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       if (formkey.currentState!.validate()) {
//                         formkey.currentState!.save();
//                         try {
//                           final userResult =
//                               await firebaseAuth.signInWithEmailAndPassword(
//                             email: email,
//                             password: password,
//                           );

//                           route(context);

//                           print(userResult.user!.email);
//                         } catch (e) {
//                           print(e.toString());
//                         }
//                       }
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 2,
//                       height: 50,
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [renk("224ABE"), renk("4E73DF")],
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Giriş Yap",
//                           style: GoogleFonts.quicksand(
//                             color: Colors.white,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Center(
//                       child: TextButton(
//                         onPressed: () =>
//                             Navigator.pushNamed(context, "/signUp"),
//                         child: Text(
//                           "kayıt Ol",
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
// }
// // Navigator.pushReplacementNamed(
// //   context,
// //   '/homePage',
// //   arguments: email,
// // );

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
