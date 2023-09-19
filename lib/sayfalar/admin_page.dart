import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enelsis_app/helper/helper_function.dart';
import 'package:enelsis_app/sabitler/ext.dart';
import 'package:enelsis_app/sayfalar/aktivationLogin.dart';
import 'package:enelsis_app/sayfalar/profile_page.dart';
import 'package:enelsis_app/service/auth_service.dart';
import 'package:enelsis_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  String groupName = "";
  int userCount = 0;
  int leaveCount = 0;
  int approvedLeaveCount = 0;
  int rejectLeaveCount = 0;
  int zamanAraligindakiLeaveSayisi = 0;
  int usernameCount = 0;
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  late String password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    getDatabaseInfo();
    _chartData= getChartData();
  }

  getDatabaseInfo()  {
      DatabaseService().getUsersCount().then((val) {
      setState(() {
        userCount = val;
        _chartData= getChartData();
        print('userCount $userCount');
      });
    });

     DatabaseService().getLeaveCount().then((val) {
      setState(() {
        leaveCount = val;
        _chartData= getChartData();
        print('leaveCount $leaveCount');
      });
    });
    
  DatabaseService().getApprovedLeaveCount().then((val) {
      setState(() {
        approvedLeaveCount = val;
        _chartData= getChartData();
        print('approvedLeaveCount $approvedLeaveCount');
      });
    });

         DatabaseService().getRejectLeaveCount().then((val) {
      setState(() {
        rejectLeaveCount = val;
        _chartData= getChartData();
        print('rejectLeaveCount $rejectLeaveCount');
      });
    });
    

    DatabaseService().getLeaveRequestsInTimeRange().then((val) {
      setState(() {
        zamanAraligindakiLeaveSayisi = val;
        _chartData= getChartData();
        print('zamanAraligindakiLeaveSayisi $zamanAraligindakiLeaveSayisi');
      });
    });

        DatabaseService().getUsernameCount().then((val) {
      setState(() {
        usernameCount = val;
        _chartData= getChartData();
        print('usernameCount $usernameCount');
      });
    });
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
            // final String department = userData['department'] as String? ?? '';

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
              Navigator.pushReplacementNamed(context, '/usersActivation');
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.person_add_alt_1_rounded),
            title: const Text(
              "Kullanıcı aktivasyon",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/leavePage');
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
              Navigator.pushReplacementNamed(context, '/groupPage');
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
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

      body: SfCircularChart(
        title: ChartTitle(text: 'PERSONEL DURUM GRAFİĞİ', textStyle: TextStyle(
              color: renk(laci), fontWeight: FontWeight.bold, fontSize: 27),),
        legend:  Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
        RadialBarSeries<GDPData, String>(
          dataSource: _chartData,
          xValueMapper: (GDPData data ,_) => data.continent,
          yValueMapper: (GDPData data ,_) => data.gdp,
          dataLabelSettings: DataLabelSettings(isVisible: true
          ),
          enableTooltip: true,
          maximumValue: 50
        )
      ],),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.add_task_outlined),
              onPressed: () {
                Navigator.pushNamed(context, '/leavePage');
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


   List<GDPData> getChartData(){
    final List<GDPData> chartData = [
    GDPData("Reddedilen İzinler", rejectLeaveCount),
    GDPData("Kabul Edilen İzinler", approvedLeaveCount),
    GDPData("izinler", leaveCount),
     GDPData("Aktivasyon İstekleri", usernameCount),
     GDPData("İzinli Personel", zamanAraligindakiLeaveSayisi),
     GDPData("Personel", userCount), 


    ];
    return chartData;
   }
}

class GDPData{
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}

///////////////////////////////////////////////////

