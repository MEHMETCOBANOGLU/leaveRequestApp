import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sabitler/tema.dart';
import 'package:enelsis_app/servis/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Tema tema = Tema();
  bool sifre_gozukme = false;

  late String user, email, password, name, department;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  var options = [
    'Üye',
    'Admin',
  ];
  var _currentItemSelected = "Üye";
  var rool = "Üye";

  // final _tEmail = TextEditingController();
  // final _tPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          // width: MediaQuery.of(context).size.width,
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
                  child: Text("Izin Alma Sistemi",
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
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                    decoration: tema.inputDec(
                        "E-Posta Adresinizi Giriniz",
                        Icons
                            .people_alt_outlined), // burda tema.darttaki input giris alani yer aliyor
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
                          },
                          onSaved: (value) {
                            password = value!;
                          },
                          obscureText: sifre_gozukme,
                          decoration: tema.inputDec(
                              "Şifrenizi Giriniz",
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
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                    decoration: tema.inputDec(
                        "Ad-Soyad Giriniz",
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
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "bilgileri eksiksiz doldurunuz";
                      } else {}
                    },
                    onSaved: (value) {
                      department = value!;
                    },
                    decoration: tema.inputDec(
                        "Departmanınızı Giriniz",
                        Icons
                            .logo_dev_sharp), // burda tema.darttaki input giris alani yer aliyor
                    style: GoogleFonts.quicksand(
                      color: renk(metin_renk),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Kayıt Türünü Seçiniz: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 116, 116, 116),
                        ),
                      ),
                      DropdownButton<String>(
                        dropdownColor: Colors.blue[900],
                        isDense: true,
                        isExpanded: false,
                        iconEnabledColor: Color.fromARGB(255, 116, 116, 116),
                        focusColor: Color.fromARGB(255, 255, 7, 7),
                        items: options.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValueSelected) {
                          setState(() {
                            _currentItemSelected = newValueSelected!;
                            rool = newValueSelected;
                          });
                        },
                        value: _currentItemSelected,
                      ),
                    ],
                  ),
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
                            email: email,
                            password: password,
                          );

                          formkey.currentState!.reset();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Kayıt yapıldı, giriş sayfasına yönlendiriliyorsunuz"),
                            ),
                          );
                          print(UserResult.user!.uid);
                          print(UserResult.user!.email);

                          Navigator.pushReplacementNamed(context, "/loginPage");

                          saveUserDataToFirestore(
                            UserResult.user!.uid,
                            email,
                            password,
                            name,
                            department,
                            rool,
                          );
                        } catch (e) {
                          print(e.toString());
                        }
                      } else {
                        // Validation failed
                      }
                    },
                    child: Center(
                      child: Text(
                        "Hesap Oluştur",
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
                          Navigator.pushNamed(context, "/loginPage"),
                      child: Text(
                        "Giriş sayfasına geri dön",
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

// Kullanıcının Firestore'a verilerini kaydetme
void saveUserDataToFirestore(String userId, String email, String password,
    String name, String department, String rool) async {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  await usersCollection.doc(userId).set({
    'email': email,
    'password': password,
    'name': name,
    'department': department,
    'rool': rool
  });
}
