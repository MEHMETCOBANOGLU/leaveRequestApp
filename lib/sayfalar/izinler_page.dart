import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/sabitler/leaveCardUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../sabitler/ext.dart';

class IzinlerSayfasi extends StatefulWidget {
  const IzinlerSayfasi({super.key});

  @override
  State<IzinlerSayfasi> createState() => _IzinlerSayfasiState();
}

class _IzinlerSayfasiState extends State<IzinlerSayfasi> {
  final _firestore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Geri dön
          },
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection('users').doc(_currentUser!.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text(
                  'Veri yüklenirken bir hata oluştu: ${snapshot.error}');
            }

            // final userData =
            //     snapshot.data?.data() as Map<String, dynamic>? ?? {};
            // final String name = userData['name'] as String? ?? '';
            // final String department = userData['department'] as String? ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text("İzinler",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: "Great Vibes",
                          fontStyle: FontStyle.italic,
                        ))),
                // Text(department, style: TextStyle(fontSize: 14)),
              ],
            );
          },
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
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: () {
          //     // Çıkış işlemi burada yapılabilir
          //   },
          // ),
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







      //       body: Column(
      //   children: [
      //     const Card(
      //       margin: EdgeInsets.all(10),
      //       color: Colors.white,
      //       child: SizedBox(height: 100, width: 100),
      //       shape: StadiumBorder(),
      //     ),
      //     Card(
      //       color: Theme.of(context).colorScheme.error,
      //       child: const SizedBox(height: 100, width: 100),
      //     )
      //   ],
      // ),
      /////////////////////////////////////

      // body: StreamBuilder<QuerySnapshot>(
      //     stream: _authService.getUsers(), // Veri akışı
      //     // stream: _firestore
      //     //     .collection("users")
      //     //     .doc(_currentUser!.uid)
      //     //     .collection('leaveRequests')
      //     //     .snapshots(),
      //     builder: (context, snapshot) {
      //       return !snapshot.hasData
      //           ? CircularProgressIndicator()
      //           : ListView.builder(
      //               itemCount: snapshot.data!.docs.length,
      //               itemBuilder: (context, index) {
      //                 DocumentSnapshot myuser = snapshot.data!.docs[index];

      //                 return Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Column(
      //                     children: [
      //                       Text("${myuser["izinTipi"]}"),
      //                       Container(),
      //                     ],
      //                   ),
      //                 );
      //               });
      //     }),