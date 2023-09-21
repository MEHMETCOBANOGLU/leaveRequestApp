import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/sabitler/leaveCardUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../sabitler/ext.dart';

class UsersLeaveRequest extends StatefulWidget {
  const UsersLeaveRequest({super.key});

  @override
  State<UsersLeaveRequest> createState() => _UsersLeaveRequestState();
}

class _UsersLeaveRequestState extends State<UsersLeaveRequest> {
  final _firestore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;

  String username = "";
  String email = "";
  String department = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),

        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: const Text(
          "İzinler",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 1),
            child: SizedBox(
              height: 200,
              width: 140,
              child: Image.asset("assets/enelsis_logo2.png"),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('leaveRequests')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot leaveSnapshot = snapshot.data!.docs[index];

                String izinTipi = leaveSnapshot["izinTipi"] as String? ?? "";
                String izinGunSayisi =
                    leaveSnapshot["izinGunSayisi"] as String? ?? "";
                Timestamp selectedBaslangicTarihi =
                    leaveSnapshot["baslangicTarihi"] as Timestamp? ??
                        Timestamp.now();
                Timestamp selectedBitisTarihi =
                    leaveSnapshot["bitisTarihi"] as Timestamp? ??
                        Timestamp.now();
                String izinAlmaNedeni =
                    leaveSnapshot["izinAlmaNedeni"] as String? ?? "";
                String onay = leaveSnapshot['onay'] as String? ?? "";   

                // Kullanıcının belgesinden izin talebi çekerken kullanılan userId

                return StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(_currentUser!.uid)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    var userData =
                        userSnapshot.data?.data() as Map<String, dynamic>? ??
                            {};
                    var name = userData['name'] as String? ?? "";
                    var department = userData['department'] as String? ?? "";

                    // Kullanıcı verilerini kullanarak leaveCard oluşturun
                    return LeaveCardU(
                      izinTipi: izinTipi,
                      izinGunSayisi: izinGunSayisi,
                      selectedBaslangicTarihi: selectedBaslangicTarihi,
                      selectedBitisTarihi: selectedBitisTarihi,
                      izinAlmaNedeni: izinAlmaNedeni,
                      name: name,
                      department: department,
                      onay: onay, 
                      onDelete: () {
                        // Firestore'dan izni silme işlemini gerçekleştirin
                        _firestore
                            .collection('users')
                            .doc(_currentUser!.uid)
                            .collection('leaveRequests')
                            .doc(leaveSnapshot
                                .id) // Silinecek belgenin ID'sini belirtin
                            .delete()
                            .then((_) {
                          // Silme işlemi başarılıysa yapılacak işlemler
                          print('İzin belgesi silindi.');
                        }).catchError((error) {
                          // Silme işlemi başarısız olursa hata işlemleri
                          print(
                              'İzin belgesi silinirken bir hata oluştu: $error');
                        });
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}



