import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sabitler/tema.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivationForm extends StatefulWidget {
  final String? userId;
  ActivationForm(this.userId, {super.key});

  @override
  State<ActivationForm> createState() => _ActivationFormState();
}

class _ActivationFormState extends State<ActivationForm> {
  void saveActivationDataToFirestore(String nickName, String password) async {
    try {
      DocumentReference userDocumentRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);

      await userDocumentRef.update({
        'password': password,
      });

      DocumentSnapshot userSnapshot = await userDocumentRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> existingData =
            userSnapshot.data() as Map<String, dynamic>;
        existingData['username'] = nickName;

        await userDocumentRef.set(existingData);
      }

      print('Veriler başarıyla Firestore\'a kaydedildi.');
    } catch (e) {
      print('Hata: $e');
    }
  }

  ///

/////////////////
  Tema tema = Tema();
  bool sifre_gozukme = false;

  late String user, email, password, name, department, nickName;
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
                  child: Text('Kullanıcı Aktivasyon ${widget.userId}',
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
                          saveActivationDataToFirestore(
                            nickName,
                            password,
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
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, "/aktivationLogin"),
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
