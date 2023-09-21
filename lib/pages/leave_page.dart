import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/service/auth_service.dart';
import 'package:enelsis_app/service/database_service.dart';
import 'package:enelsis_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:enelsis_app/sabitler/leaveCard.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final _firestore = FirebaseFirestore.instance;
  String username = "";
  String email = "";
  String department = "";
  bool _isLoading = false;
  String groupName = "";

  late String password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((val) {
      setState(() {
        email = val!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        username = val!;
      });
    });
    await HelperFunctions.getUserDepartmentFromSF().then((val) {
      setState(() {
        department = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, "/adminPage");
          },
        ),
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
                        String uidd = userSnapshot["uid"] as String? ?? "";
                        String leavedepartment =
                            userSnapshot["department"] as String? ?? "";

                        if (department != leavedepartment) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 250,
                                ),
                                Center(
                                  child: const Text(
                                    "Herhangi bir izin talebi bulunmamaktadır",
                                    style: TextStyle(fontSize: 30),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return LeaveCard(
                            izinTipi: izinTipi,
                            izinGunSayisi: izinGunSayisi,
                            selectedBaslangicTarihi: selectedBaslangicTarihi,
                            selectedBitisTarihi: selectedBitisTarihi,
                            izinAlmaNedeni: izinAlmaNedeni,
                            onay: onay,
                            name: name,
                            department: leavedepartment,
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
                            }, ////////////////////////////////////////

                            onMessage: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: ((context, setState) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Sohbet grubu  oluştur",
                                          textAlign: TextAlign.left,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _isLoading == true
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                  )
                                                : TextField(
                                                    onChanged: (val) {
                                                      setState(() {
                                                        groupName = val;
                                                      });
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Theme.of(context)
                                                                    .primaryColor),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    20)),
                                                        errorBorder: OutlineInputBorder(
                                                            borderSide: const BorderSide(
                                                                color:
                                                                    Colors.red),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    20)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Theme.of(context).primaryColor),
                                                            borderRadius: BorderRadius.circular(20))),
                                                  ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor),
                                            child: const Text(
                                              "İptal",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (groupName != "") {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                String newGroupId =
                                                    await DatabaseService(
                                                            uid: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                        .createGroup(
                                                            username,
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            groupName);

                                                await DatabaseService(uid: uidd)
                                                    .groupJoin(newGroupId, name,
                                                        groupName, uidd)
                                                    .whenComplete(() {
                                                  _isLoading = false;
                                                });
                                                Navigator.pop(context);
                                                showSnackbar(
                                                    context,
                                                    Colors.green,
                                                    "Grup başarılı bir şekilde oluşturuldu.");
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor),
                                            child: const Text(
                                              "Oluştur",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    }));
                                  });
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
                        }
                      }).toList(),
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


