import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/pages/aktivationLogin.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/pages/profile_page.dart';
import 'package:enelsis_app/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../sabitler/theme.dart';

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

  String onay = '';
  String username = "";
  String department = "";
  final izinGunSayisiController = TextEditingController();
  final izinAlmaNedeniController = TextEditingController();
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
    //CollectionReference usersRef = _firestore.collection("users");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: renk(laci),

        title: const Text(
          "İzin Başvurusu",
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
              print(department);
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
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AktivationLogin()),
                                (route) => false);
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
                controller: izinGunSayisiController,
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
                controller: izinAlmaNedeniController,
                decoration: InputDecoration(labelText: "İzin Alma Nedeni"),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  leaveButoon();
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
              Navigator.pushNamed(context, "/groupPage");
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
              width: 16), 
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
            backgroundColor: renk(laci),
          ),
        ],
      ),
    );
  }

  leaveButoon() async {
    // İzin talebi verilerini al
    final String izinGunSayisi = izinGunSayisiController.text.trim();
    final String izinAlmaNedeni = izinAlmaNedeniController.text.trim();

    DateTime? selectedBaslangicTarihi = baslangicTarihi;
    DateTime? selectedBitisTarihi = bitisTarihi;

    if (izinTipi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("İzin tipi kısmı boş bırakılamaz."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    //
    if (selectedBaslangicTarihi == null || selectedBitisTarihi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Başlangıç ve bitiş tarihlerini seçmelisiniz."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final fark = selectedBitisTarihi.difference(selectedBaslangicTarihi);
    final kalanGun = fark.inDays;

    int izinGunSayisiInt = int.parse(izinGunSayisi);
    if (izinGunSayisiInt != kalanGun) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("İzin alacağınız gün sayısını doğru giriniz."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Başlangıç tarihi bitiş tarihinden önce veya aynı olmalıdır
    if (selectedBaslangicTarihi == null ||
        selectedBitisTarihi == null ||
        selectedBaslangicTarihi.isAfter(selectedBitisTarihi)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Geçerli bir başlangıç ve bitiş tarihi seçmelisiniz."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Başlangıç tarihi seçilen yıl ile güncel yıl arasında olmalıdır

    final currentTime = DateTime.now();
    final currentDay = currentTime.day;
    final currentMonth = currentTime.month;
    final currentYear = currentTime.year;

    final baslangicDay = selectedBaslangicTarihi?.day ?? 0;
    final baslangicMonth = selectedBaslangicTarihi?.month ?? 0;
    final baslangicYear = selectedBaslangicTarihi?.year ?? 0;

    final bitisDay = selectedBitisTarihi?.day ?? 0;
    final bitisMonth = selectedBitisTarihi?.month ?? 0;
    final bitisYear = selectedBitisTarihi?.year ?? 0;

    if (bitisYear < currentYear ||
        (bitisYear == currentYear && bitisMonth < currentMonth) ||
        (bitisYear == currentYear &&
            bitisMonth == currentMonth &&
            bitisDay < currentDay) ||
        baslangicYear < currentYear ||
        (baslangicYear == currentYear && baslangicMonth < currentMonth) ||
        (baslangicYear == currentYear &&
            baslangicMonth == currentMonth &&
            baslangicDay < currentDay)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Geçerli bir tarih giriniz."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (izinAlmaNedeni.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("İzin alma nedeni kısmı boş bırakılamaz."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      DocumentReference izinTalebiRef = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('leaveRequests')
          .add({
        'izinTipi': izinTipi,
        'izinGunSayisi': izinGunSayisi,
        'baslangicTarihi': selectedBaslangicTarihi,
        'bitisTarihi': selectedBitisTarihi,
        'izinAlmaNedeni': izinAlmaNedeni,
        'onay': onay,
      });
      setState(() {
        izinTipi = '';
        izinGunSayisiController.clear();
        baslangicTarihi = null;
        bitisTarihi = null;
        izinAlmaNedeniController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("İzin talebi başarıyla kaydedildi."),
          backgroundColor: Colors.green,
        ),
      );
      // Başvuru başarılı mesajı veya işlem
      print('İzin talebi başarıyla kaydedildi. ID: ${izinTalebiRef.id}');
    } catch (e) {
      // Başvuru hata mesajı veya işlem
      print('İzin talebi kaydedilirken bir hata oluştu: $e');
    }
  }
}



  

