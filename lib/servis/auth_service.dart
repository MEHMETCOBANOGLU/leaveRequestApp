import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
//   final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

//   Future<void> signIn({required String email, required String password}) async {
//     try {
//       final UserCredential userCredential = await firebaseAuth
//           .signInWithEmailAndPassword(email: email, password: password);
//       if (userCredential.user != null) {
//         Fluttertoast.showToast(
//             msg: "GIRIS BASARILI", toastLength: Toast.LENGTH_LONG);
//       }
//     } on FirebaseAuthException catch (e) {
//       Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
//     }
//   }
  // veri ekleme fonksiyonu

  //helloworld

  final _firestore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;
  //veri gosterme fonksiyonu
  Stream<QuerySnapshot> getUsers() {
    var ref = _firestore
        .collection("users")
        .doc(_currentUser!.uid)
        .collection('leaveRequests')
        .snapshots();

    return ref;
  }

  // veri silme fonksiyonu
  Future<void> removeStatus(String docId) async {
    var ref = _firestore.collection("users").doc(docId).delete();

    return ref;
  }
}
