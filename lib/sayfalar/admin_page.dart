import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sayfalar/aktivationLogin.dart';
import 'package:enelsis_app/sayfalar/group_page.dart';
import 'package:enelsis_app/sayfalar/profile_page.dart';
import 'package:enelsis_app/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:enelsis_app/sabitler/leaveCard.dart';

class adminPage extends StatefulWidget {
  const adminPage({super.key});

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
  final _firestore = FirebaseFirestore.instance;
  String username = "";
  String email = "";
  String department = "";

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
    final _currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // Çıkış işlemi burada yapılabilir
        //     Navigator.pop(context); // Geri dön
        //   },
        // ),
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
      ////////////////////////////////////////1.48.dk

      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            username,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/groupPage');
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Grup",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.auto_graph_outlined),
            title: const Text(
              "Rapor ve istatistik",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    username: username,
                    email: email,
                    department: department,
                  ),
                ),
              );

              // nextScreenReplace(
              //     context,
              //     ProfilePage(
              //       userName: userName,
              //       email: email,
              //     ));
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Profil",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Çıkış yap"),
                      content: const Text(
                          "Çıkış yapmak istediğinizden emin misiniz?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            // await authService.signOut();
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const AktivationLogin()),
                            //     (route) => false);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      )),

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
                            print(userSnapshot.id);
                            final userid = userSnapshot.id;
                            Navigator.pushReplacementNamed(
                              context,
                              "/chatPage",
                              arguments: userid,
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
              onPressed: () {
                Navigator.pushNamed(context, '/adminPage');
              },
            ),
            label: 'İzinler',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person_add_alt_1),
              onPressed: () {
                Navigator.pushNamed(context, '/usersActivation');
              },
            ),
            label: 'Kullanıcı Aktivasyon',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.pushNamed(context, '/chatDm');
              },
            ),
            label: 'Mesaj ',
          ),
        ],
        //selectedItemColor: Colors.blue,
      ),
    );
  }
}

///////////////////////////////////////////////////

