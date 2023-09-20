import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sabitler/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RootAdmin extends StatefulWidget {
  const RootAdmin({super.key});

  @override
  State<RootAdmin> createState() => _RootAdminState();
}

class _RootAdminState extends State<RootAdmin> {
  Tema tema = Tema();
  bool sifre_gozukme = false;

  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  final lisansController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: renk(arka_renk)),
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
                    child: Text("ROOT ADMİN GİRİŞ",
                        style: GoogleFonts.bebasNeue(
                          color: renk(laci),
                          fontSize: 30,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    decoration:
                        tema.inputBoxDec(), // temadan gelen box decaration
                    padding:
                        EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    child: TextFormField(
                      controller: lisansController,

                      decoration: tema.inputDec(
                          "Lisans Id Giriniz",
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
                            controller: passwordController,

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
                  InkWell(
                    onTap: () async {
                      final String lisans = lisansController.text.trim();
                      final String password = passwordController.text.trim();
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();

                        if (lisans == "123123" && password == "123123") {
                          // Eğer doğru lisans ID ve şifre girildiyse, Aktivasyon Girişi sayfasına git
                          Navigator.pushReplacementNamed(
                              context, "/rootAdminPage");
                        } else {
                          print("Geçersiz lisans ID veya şifre");
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [renk("224ABE"), renk("4E73DF")],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Giriş Yap",
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1),
                  Container(
                    child: Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, "/"),
                        child: Text(
                          "bir önceki sayfaya geri dön",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
