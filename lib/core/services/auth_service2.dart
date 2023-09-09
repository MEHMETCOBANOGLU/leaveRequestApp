// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Stream<User?> get authStateChanges => _auth.idTokenChanges();

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

//   ////////////////////
//   User? get currentUser =>
//       _auth.currentUser; // Future<User> get currentUser => _auth.currentUser;

//   //////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   // Future<void> signIn({required String email, required String password}) async {
//   //   try {
//   //     var UserResult = await _auth.createUserWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );

//   //     ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//   //       SnackBar(
//   //         content: Text("Kayıt yapıldı, giriş sayfasına yönlendiriliyorsunuz"),
//   //       ),
//   //     );
//   //     //  print(UserResult.user!.uid);
//   //     //print(UserResult.user!.email);
//   //     Navigator.pushReplacementNamed(context as BuildContext, "/");
//   //     saveUserDataToFirestore(UserResult.user!.uid, email, password);
//   //   } catch (e) {
//   //     print(e.toString());
//   //   }
//   // }
//   ///////////////////////////////////////////////////
// }
