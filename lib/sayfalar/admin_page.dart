import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:enelsis_app/sabitler/leaveCard.dart';

import '../messaging/chat_page.dart';
import 'usersActivation_page.dart';

class adminPage extends StatefulWidget {
  const adminPage({super.key});

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
  final _firestore = FirebaseFirestore.instance;

  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Çıkış işlemi burada yapılabilir
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

            final userData =
                snapshot.data?.data() as Map<String, dynamic>? ?? {};
            final String name = userData['name'] as String? ?? '';
            final String department = userData['department'] as String? ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 18)),
                Text(department, style: TextStyle(fontSize: 14)),
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
      ////////////////////////////////////////

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot userSnapshot = snapshot.data!.docs[index];

                return StreamBuilder<QuerySnapshot>(
                  stream: userSnapshot.reference
                      .collection('leaveRequests')
                      .snapshots(),
                  builder: (context, leaveSnapshot) {
                    if (!leaveSnapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    return Column(
                      children: leaveSnapshot.data!.docs.map((leaveDoc) {
                        String izinTipi = leaveDoc["izinTipi"] as String? ?? "";
                        String izinGunSayisi =
                            leaveDoc["izinGunSayisi"] as String? ?? "";
                        Timestamp selectedBaslangicTarihi =
                            leaveDoc["baslangicTarihi"] as Timestamp? ??
                                Timestamp.now();
                        Timestamp selectedBitisTarihi =
                            leaveDoc["bitisTarihi"] as Timestamp? ??
                                Timestamp.now();
                        String izinAlmaNedeni =
                            leaveDoc["izinAlmaNedeni"] as String? ?? "";
                        String onay = leaveDoc["onay"] as String? ?? "";

                        String name = userSnapshot["name"] as String? ?? "";

                        return LeaveCard(
                          izinTipi: izinTipi,
                          izinGunSayisi: izinGunSayisi,
                          selectedBaslangicTarihi: selectedBaslangicTarihi,
                          selectedBitisTarihi: selectedBitisTarihi,
                          izinAlmaNedeni: izinAlmaNedeni,
                          onay: onay,
                          name: name,
                          department:
                              userSnapshot["department"] as String? ?? "",
                          onApprove: () {
                            setState(() async {
                              onay = "ONAYLANDI";
                              print(onay);

                              // Kullanıcının izin talebinin bulunduğu koleksiyon referansını alın
                              CollectionReference leaveRequestsCollection =
                                  userSnapshot.reference
                                      .collection('leaveRequests');

                              // İzin taleplerinin koleksiyonundaki tüm dokümanları alın
                              QuerySnapshot querySnapshot =
                                  await leaveRequestsCollection.get();

                              // Tüm izin talebi dokümanlarını dönüp onay alanını güncelleyin
                              for (QueryDocumentSnapshot leaveDoc
                                  in querySnapshot.docs) {
                                leaveDoc.reference.update({
                                  'onay': onay,
                                }).then((_) {
                                  print(
                                      'İzin talebi onay bilgisi güncellendi.');
                                }).catchError((error) {
                                  print(
                                      'İzin talebi onay bilgisi güncellenirken hata oluştu: $error');
                                });
                              }
                            });
                          },
                          onReject: () {
                            setState(() async {
                              onay = "REDDEDİLDİ";
                              print(onay);
                              // Kullanıcının izin talebinin bulunduğu koleksiyon referansını alın
                              CollectionReference leaveRequestsCollection =
                                  userSnapshot.reference
                                      .collection('leaveRequests');

                              // İzin taleplerinin koleksiyonundaki tüm dokümanları alın
                              QuerySnapshot querySnapshot =
                                  await leaveRequestsCollection.get();

                              // Tüm izin talebi dokümanlarını dönüp onay alanını güncelleyin
                              for (QueryDocumentSnapshot leaveDoc
                                  in querySnapshot.docs) {
                                leaveDoc.reference.update({
                                  'onay': onay,
                                }).then((_) {
                                  print(
                                      'İzin talebi onay bilgisi güncellendi.');
                                }).catchError((error) {
                                  print(
                                      'İzin talebi onay bilgisi güncellenirken hata oluştu: $error');
                                });
                              }
                            });
                          },
                          onMessage: () {
                            Navigator.pushNamed(
                              context,
                              "/chatPage",
                              arguments: {'name': name},
                            );
                          },
                          onDelete: () async {
                            try {
                              await userSnapshot.reference
                                  .collection('leaveRequests')
                                  .doc(leaveDoc.id)
                                  .delete();

                              print('Kullanıcının izin belgesi silindi.');
                            } catch (error) {
                              print(
                                  'Kullanıcının izin belgesi silinirken bir hata oluştu: $error');
                            }
                          },
                        );
                      }).toList(),
                    );
                  },
                );
              },
            );
          }
        },
      ),

      //////////////////////////person_add_alt_1

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.add_task_outlined),
              onPressed: () {},
            ),
            label: 'İzinler',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person_add_alt_1),
              onPressed: () {
                Navigator.pushNamed(context, "/usersActivation");
              },
            ),
            label: 'Kullanıcı Aktivasyon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mesaj',
          ),
        ],
        selectedItemColor: Colors.blue,
      ),
    );
  }
}

///////////////////////////////////////////////////

