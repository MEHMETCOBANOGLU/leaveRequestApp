import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sabitler/tema.dart';
import 'package:enelsis_app/service/auth_service.dart';
import 'package:enelsis_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
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
  bool _isLoading = false;

  late String user, email, password, name, department = "";
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  AuthService authService = AuthService();

  var options = [
    'Üye',
    'Admin',
  ];
  var _currentItemSelected = "Üye";
  var rool = "Üye";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,

        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16), // ekran boyutunu ayarlamada cozebildim
        decoration: BoxDecoration(color: renk(arka_renk)),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SingleChildScrollView(
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
                      child: Text("Kayıt Ol",
                          style: GoogleFonts.bebasNeue(
                            color: renk("224ABE"),
                            fontSize: 30,
                          )),
                    ),
                    Container(
                      decoration: tema.inputBoxDec(),
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 5),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "bilgileri eksiksiz doldurunuz";
                          } else {}
                          return null;
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
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 15),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 10),
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
                      decoration: tema.inputBoxDec(),
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 5),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "bilgileri eksiksiz doldurunuz";
                          } else {}
                          return null;
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
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 5),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "bilgileri eksiksiz doldurunuz";
                          } else {}
                          return null;
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
                            iconEnabledColor:
                                Color.fromARGB(255, 116, 116, 116),
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
                        //////////////////////////////////////////////////////////////////////
                        onTap: () async {
                          SignUP();
                          //   try {
                          //     var UserResult = await firebaseAuth
                          //         .createUserWithEmailAndPassword(
                          //       email: email,
                          //       password: password,
                          //     );
                          //     formkey.currentState!.reset();
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         content: Text(
                          //             "Kayıt yapıldı, giriş sayfasına yönlendiriliyorsunuz"),
                          //       ),
                          //     );
                          //     //  print(UserResult.user!.uid);
                          //     //print(UserResult.user!.email);
                          //     Navigator.pushReplacementNamed(context, "/");
                          //     saveUserDataToFirestore(
                          //       UserResult.user!.uid,
                          //       email,
                          //       password,
                          //       name,
                          //       department,
                          //       rool,
                          //     );
                          //   } catch (e) {
                          //     print(e.toString());
                          //   }
                          // } else {
                          //   // Validation failed
                          // }
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(TextSpan(
                        text: "Zaten bir hesabınız var mı? ",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Giriş Yap",
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, "/");
                                }),
                        ],
                      )),
                    ),
                  ],
                ),
              )),
      ),
    );
  }

  SignUP() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      setState(() {
        _isLoading = false;
      });
      await authService
          .registerUserWithEmailandPassword(
              name, email, password, department, rool)
          .then(
        (value) async {
          if (value == true) {
            // saving the shared preference state
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(email);
            await HelperFunctions.saveUserNameSF(name);
            await HelperFunctions.saveUserDepartmentSF(department);
            Navigator.pushReplacementNamed(context, "/");
          } else {
            showSnackbar(context, Colors.red, value);

            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    }
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
