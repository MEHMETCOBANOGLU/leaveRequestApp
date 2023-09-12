import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sayfalar/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../sabitler/tema.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Tema tema = Tema();
  bool sifre_gozukme = false;
  bool userIsAdmin = false;

  final _firestore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;
  late String email, password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  DateTime? baslangicTarihi;
  DateTime? bitisTarihi;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  String izinTipi = '';
  String izinGunSayisi = '';
  String izinAlmaNedeni = '';
  String onay = '';
  String username = "";
  String department = "";

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
    //CollectionReference usersRef = _firestore.collection("users");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),

        title: const Text(
          "İzin Başvurusu",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
        // title: StreamBuilder<DocumentSnapshot>(
        //   stream:
        //       _firestore.collection('users').doc(_currentUser?.uid).snapshots(),
        //   builder:
        //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return CircularProgressIndicator();
        //     }

        //     if (snapshot.hasError) {
        //       return Text(
        //           'Veri yüklenirken bir hata oluştu: ${snapshot.error}');
        //     }
        //     print(_currentUser!.uid);
        //     final userData =
        //         snapshot.data?.data() as Map<String, dynamic>? ?? {};
        //     final String name = userData['name'] as String? ?? '';
        //     final String department = userData['department'] as String? ?? '';

        //     return Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(name, style: TextStyle(fontSize: 18)),
        //         Text(department, style: TextStyle(fontSize: 14)),
        //       ],
        //     );
        //   },

        // ),
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
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.person),
            title: const Text(
              "Profil",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, "/usersLeaveRequest");
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.add_task_sharp),
            title: const Text(
              "İzinler",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/groupPage');
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.message_sharp),
            title: const Text(
              "Sohbet Grupları",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                onChanged: (value) {
                  setState(() {
                    izinTipi = value!;
                  });
                },
                items: [
                  "Yıllık İzin",
                  "Doğum İzni",
                  "Hastalık İzni",
                  "Annelik/Babalık İzni"
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: "İzin Tipi"),
              ),
              SizedBox(height: 16), //kaldirabiliriisn
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    izinGunSayisi = value;
                  });
                },
                decoration:
                    InputDecoration(labelText: "Kaç Gün İzin Alacaksınız?"),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            baslangicTarihi = selectedDate;
                          });
                        }
                      },
                      decoration:
                          InputDecoration(labelText: "Başlangıç Tarihi"),
                      controller: TextEditingController(
                          text: baslangicTarihi != null
                              ? dateFormat.format(baslangicTarihi!)
                              : ""),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            bitisTarihi = selectedDate;
                          });
                        }
                      },
                      decoration: InputDecoration(labelText: "Bitiş Tarihi"),
                      controller: TextEditingController(
                          text: bitisTarihi != null
                              ? dateFormat.format(bitisTarihi!)
                              : ""),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    izinAlmaNedeni =
                        value; // Girilen izin alma nedenini güncelle
                  });
                },
                decoration: InputDecoration(labelText: "İzin Alma Nedeni"),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // // İzin talebi verilerini al
                  // String izinTipi =  izinTipi; // Dropdown'dan seçilen değer
                  // int izinGunSayisi = izinGunSayisi; // TextFormField'dan alınan değer
                  DateTime? selectedBaslangicTarihi = baslangicTarihi;
                  DateTime? selectedBitisTarihi = bitisTarihi;

                  Timestamp baslangicTarihiTimestamp =
                      Timestamp.fromDate(selectedBaslangicTarihi!);
                  Timestamp bitisTarihiTimestamp =
                      Timestamp.fromDate(selectedBitisTarihi!);

                  // String izinAlmaNedeni = izinAlmaNedeni; // TextFormField'dan alınan değer

                  // Firestore'a izin talebi verilerini kaydet
                  try {
                    DocumentReference izinTalebiRef = await _firestore
                        .collection('users')
                        .doc(_currentUser!.uid)
                        .collection('leaveRequests')
                        .add({
                      'izinTipi': izinTipi,
                      'izinGunSayisi': izinGunSayisi,
                      'baslangicTarihi': selectedBaslangicTarihi,
                      'bitisTarihi': selectedBitisTarihi,
                      'izinAlmaNedeni': izinAlmaNedeni,
                      'onay': onay,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("İzin talebi başarıyla kaydedildi."),
                      ),
                    );
                    // Başvuru başarılı mesajı veya işlem
                    print(
                        'İzin talebi başarıyla kaydedildi. ID: ${izinTalebiRef.id}');
                  } catch (e) {
                    // Başvuru hata mesajı veya işlem
                    print('İzin talebi kaydedilirken bir hata oluştu: $e');
                  }
                },
                child: Text(
                  "Başvur",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: renk(laci),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/chatDm");
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.message_sharp,
                  color: const Color.fromARGB(255, 255, 254, 255),
                  size: 24.0,
                ),
                Text(
                  "Sohbet",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            backgroundColor: renk(laci),
          ),
          SizedBox(
              width: 16), // Boşluk bırakmak için SizedBox kullanabilirsiniz
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/usersLeaveRequest");
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.assignment_turned_in_sharp,
                  color: const Color.fromARGB(255, 255, 254, 255),
                  size: 24.0,
                ),
                Text(
                  "İzinler",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),

            //child: Icon(Icons.assignment_turned_in_sharp),
            backgroundColor: renk(laci),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////


  

