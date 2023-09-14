import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sabitler/tema.dart';
import 'package:enelsis_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivationForm extends StatefulWidget {
  final String? userId;
  final String? rool;

  ActivationForm({Key? key, this.userId, this.rool}) : super(key: key);

  // ...

  @override
  State<ActivationForm> createState() => _ActivationFormState();
}

class _ActivationFormState extends State<ActivationForm> {
  ///

/////////////////
  Tema tema = Tema();
  bool sifre_gozukme = true;
  // burda dep kon rol
  late String user, email, password, name, department, nickName;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  // final _tEmail = TextEditingController();
  // final _tPassword = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  void saveActivationDataToFirestore(
      String nickName, String password, String department) async {
    try {
      DocumentReference userDocumentRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      // departmani da her iki tarafta guncelle mehemt ve admin_depatmen koleskiyonu olusmadi onu da hallet
      //artik if else kontorlu yapmana gerek kalmayabilir
      if (widget.rool == "Admin") {
        // DocumentReference adminDepartments = await _firestore
        //     .collection('users')
        //     .doc(widget.userId)
        //     .collection('admindepartment')
        //     .add({
        //   'password': password,
        //   'username': nickName,
        //   'department': department
        // });
        await userDocumentRef.update({
          'password': password,
          'username': nickName,
          'department': department
        });
      } else {
        await userDocumentRef.update({
          'password': password,
          'username': nickName,
          'department': department
        });
      }
      // DocumentSnapshot userSnapshot = await userDocumentRef.get();

      // if (userSnapshot.exists) {
      //   Map<String, dynamic> existingData =
      //       userSnapshot.data() as Map<String, dynamic>;
      //   existingData['username'] = nickName;

      //   await userDocumentRef.set(existingData);
      // }

      print('Veriler başarıyla Firestore\'a kaydedildi.');
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16), // ekran boyutunu ayarlamada cozebildim
          decoration: BoxDecoration(color: renk(arka_renk)),
          child: SingleChildScrollView(
              child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 3, bottom: 0),
                  child: SizedBox(
                    height: 200,
                    width: 800,
                    child: Image.asset("assets/enelsis_logo2.png"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text('Kullanıcı Aktivasyon',
                      style: GoogleFonts.bebasNeue(
                        color: renk("224ABE"),
                        fontSize: 30,
                      )),
                ),
                Container(
                  decoration:
                      tema.inputBoxDec(), // temadan gelen box decaration
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "bilgileri eksiksiz doldurunuz";
                      } else {}
                      return null;
                    },
                    onSaved: (value) {
                      nickName = value!;
                    },
                    decoration: tema.inputDec(
                        "kullanıcı-adı giriniz",
                        Icons
                            .person_add_alt), // burda tema.darttaki input giris alani yer aliyor
                    style: GoogleFonts.quicksand(
                      color: renk(metin_renk),
                    ),
                  ),
                ),
                Container(
                  decoration:
                      tema.inputBoxDec(), // temadan gelen box decaration
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: DropdownButtonFormField<String>(
                    onChanged: (value) {
                      setState(() async {
                        department = value!;
                      });
                    },
                    items: [
                      "Yönetim departmanı",
                      "Ar-ge departmanı",
                      "Üretim departmanı",
                      "Pazarlama departmanı",
                      "Finans departmanı",
                      "Muhasebe departmanı",
                      "İnsan kaynakları departmanı",
                      "Halka ilişkiler departmanı",
                      "Hukuk departmanı"
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Lütfen bir departman seçin";
                      }
                      return null;
                    },
                    decoration: tema.inputDec(
                        "Departman giriniz", Icons.badge_outlined),
                    style: GoogleFonts.quicksand(
                      color: renk(metin_renk),
                    ),
                  ),
                ),
                Container(
                  decoration:
                      tema.inputBoxDec(), // temadan gelen box decaration
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 15),
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "bilgileri eksiksiz doldurunuz";
                            } else {}
                            return null;
                          },
                          onSaved: (value) {
                            password = value!;
                          },
                          obscureText: sifre_gozukme,
                          decoration: tema.inputDec(
                              "Şifre Giriniz",
                              Icons
                                  .lock_outline), // burda tema.darttaki input giris alani yer aliyor
                          style: GoogleFonts.quicksand(
                            color: renk(metin_renk),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              sifre_gozukme = !sifre_gozukme;
                            });
                          },
                          icon: Icon(sifre_gozukme
                              ? Icons.close
                              : Icons.remove_red_eye),
                          color: renk(metin_renk)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [renk("224ABE"), renk("4E73DF")],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        try {
                          var UserResult =
                              await firebaseAuth.createUserWithEmailAndPassword(
                            email: "$nickName@example.com",
                            password: password,
                          );
                          formkey.currentState!.reset();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Kayıt yapıldı.."),
                            ),
                          );

                          Navigator.pop(context);
                          print(UserResult.user!.uid);
                          print(UserResult.user!.email);
                          await HelperFunctions.saveUserDepartmentSF(
                              department);
                          saveActivationDataToFirestore(
                              nickName, password, department);
                        } catch (e) {
                          print(e.toString());
                        }
                      } else {
                        // Validation failed
                      }
                    },
                    child: Center(
                      child: Text(
                        "Aktif Et",
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: TextButton(
                      onPressed: () =>
                          print(widget.rool), // Navigator.pushReplacementNamed(
                      //     context, "/aktivationLogin"),
                      //print(widget.userId),
                      child: Text(
                        "Bir önceki sayfaya geri dön",
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}

// //Kullanıcının Firestore'a verilerini kaydetme
// void saveActivationDataToFirestore(String nickName, String password) async {
//   CollectionReference usersCollection = FirebaseFirestore.instance
//       .collection('users')
//       .doc(widget.userId) as CollectionReference<Object?>;
//   await usersCollection.doc(widget.userId).set({
//     'kullanıcı-Adı': nickName,
//     'password': password,
//   });
// }
