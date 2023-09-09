import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/sabitler/ext.dart';
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

  @override
  Widget build(BuildContext context) {
    //CollectionReference usersRef = _firestore.collection("users");

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
              _firestore.collection('users').doc(_currentUser?.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text(
                  'Veri yüklenirken bir hata oluştu: ${snapshot.error}');
            }
            print(_currentUser!.uid);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "İzin Talebi",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
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
                Icon(Icons.message),
                SizedBox(height: 0),
                Text("Sohbet"),
              ],
            ),
            backgroundColor: renk(laci),
          ),
          SizedBox(
              width: 16), // Boşluk bırakmak için SizedBox kullanabilirsiniz
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/izinlerSayfasi");
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.assignment_turned_in_sharp),
                SizedBox(height: 0),
                Text("İzinler"),
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


  

