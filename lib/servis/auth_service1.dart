// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// // import 'package:fluttertoast/fluttertoast.dart';

// class AuthService {
//   final FirebaseAuth _auth;
//   AuthService(this._auth);

//   Stream<User?> get authStateChanges => _auth.idTokenChanges();

//   // Future<Object> login(String email, String password) async {
//   //   try {
//   //     final userR = await _auth.signInWithEmailAndPassword(
//   //         email: email, password: password);
//   //     // print(userR.user!.email);
//   //     return "Logged In";
//   //   } catch (e) {
//   //     return e;
//   //   }
//   // }

//   ////////////////////
//   // static void route(BuildContext context) async {
//   //   final user = FirebaseAuth.instance.currentUser;
//   //   if (user != null) {
//   //     final documentSnapshot = await FirebaseFirestore.instance
//   //         .collection('users')
//   //         .doc(user.uid)
//   //         .get();

//   //     if (documentSnapshot.exists) {
//   //       if (documentSnapshot.get('rool') == "Admin") {
//   //         Navigator.pushReplacementNamed(context, "/adminPage");
//   //       } else {
//   //         Navigator.pushReplacementNamed(context, "/homePage");
//   //       }
//   //     } else {
//   //       print('Document does not exist on the database');
//   //     }
//   //   }
//   // }

//   ///
//   // Future<String> signUp(
//   //     String email, String password, String role, String username) async {
//   //   try {
//   //     await _auth
//   //         .createUserWithEmailAndPassword(email: email, password: password)
//   //         .then((value) async {
//   //       User? user = FirebaseAuth.instance.currentUser;

//   //       await FirebaseFirestore.instance
//   //           .collection("users")
//   //           .doc(user!.uid)
//   //           .set({
//   //         'uid': user!.uid,
//   //         'email': email,
//   //         'username': username,
//   //         'password': password,
//   //         'role': role
//   //       });
//   //     });
//   //     return "Signed Up";
//   //   } catch (e) {
//   //     print(e.toString());
//   //     return e.toString();
//   //   }
//   // }

//   ///

// //   final userCollection = FirebaseFirestore.instance.collection("users");
//   final firebaseAuth = FirebaseAuth.instance;

// //   Future<void> signIn({required String email, required String password}) async {
// //     try {
// //       final UserCredential userCredential = await firebaseAuth
// //           .signInWithEmailAndPassword(email: email, password: password);
// //       if (userCredential.user != null) {
// //         Fluttertoast.showToast(
// //             msg: "GIRIS BASARILI", toastLength: Toast.LENGTH_LONG);
// //       }
// //     } on FirebaseAuthException catch (e) {
// //       Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
// //     }
// //   }
//   // veri ekleme fonksiyonu

//   //helloworld

//   final _firestore = FirebaseFirestore.instance;
//   final _currentUser = FirebaseAuth.instance.currentUser;
//   //veri gosterme fonksiyonu
//   Stream<QuerySnapshot> getUsers() {
//     var ref = _firestore
//         .collection("users")
//         .doc(_currentUser!.uid)
//         .collection('leaveRequests')
//         .snapshots();

//     return ref;
//   }

//   // veri silme fonksiyonu
//   Future<void> removeStatus(String docId) async {
//     var ref = _firestore.collection("users").doc(docId).delete();

//     return ref;
//   }
// }
