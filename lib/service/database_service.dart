import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
        final CollectionReference leaveRequestsCollection =
      FirebaseFirestore.instance.collection("leaveRequests");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving the userdata
  Future savingUserData(
      String name, String email, String department, String rool) async {
    return await userCollection.doc(uid).set({
      "name": name,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
      "department": department,
      "rool": rool,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
  //getin usser username dataa
  // Future gettingUserData(String username) async {
  //   QuerySnapshot snapshot = await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("username", isEqualTo: username)
  //       .get();
  //   return snapshot;
  // }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // get user activation
  getUserActivation() async {
    return userCollection.doc(uid).snapshots();
  }

 // creating a group
  Future ccreateGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // creating a group
  Future<String> createGroup(
      String username, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$username",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$username"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });

    return groupDocumentReference.id; // Oluşturulan grup ID'sini dön
  }

  ///
  Future groupJoin(String groupId, String username, String groupName,
      String otherUserId) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(otherUserId);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${otherUserId}_$username"])
    });

    await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
    });
  }

  ////////////////////
  // users daki droups belgesine grubu ekleme:
  Future GroupJoin(String groupId, String username, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join

    await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
    });
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$username"])
    });
  }
  /////////////////////

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String username) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String username, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$username"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$username"])
      });
    }
  }

  ///group join

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }


    // Kullanıcı sayısını elde etmek için bir fonksiyon
   getUsersCount() async {
    QuerySnapshot userDocs = await userCollection.get();
    return userDocs.size; // Doküman sayısını döndürür
  }

   // Firestore'daki "users" koleksiyonu altındaki tüm dokümantasyonların içindeki "leaveRequests" koleksiyonlarının sayısını elde etmek için fonksiyon
  Future<int> getLeaveCount() async {
    int leaveCount = 0;
    QuerySnapshot userDocs = await userCollection.get();
    
    for (QueryDocumentSnapshot userDoc in userDocs.docs) {
      
      CollectionReference leaveRequestsCollection =
          userDoc.reference.collection("leaveRequests");
      
      QuerySnapshot leaveRequests = await leaveRequestsCollection.get();
      
      leaveCount += leaveRequests.size;
    }
  
    return leaveCount;
  }
  
  

 // Firestore'daki "users" koleksiyonu altındaki tüm dokümantasyonların içindeki "leaveRequests" koleksiyonlarının
// içindeki dokümantasyonların onay belgesi "ONAYLANDI" olanlarının sayısını elde etmek için fonksiyon
Future<int> getApprovedLeaveCount() async {
  int approvedLeaveCount = 0;

  QuerySnapshot userDocs = await userCollection.get();


  for (QueryDocumentSnapshot userDoc in userDocs.docs) {

    CollectionReference leaveRequestsCollection =
        userDoc.reference.collection("leaveRequests");

    QuerySnapshot approvedLeaveRequests = await leaveRequestsCollection
        .where("onay", isEqualTo: "ONAYLANDI")
        .get();

    approvedLeaveCount += approvedLeaveRequests.size;
  }

  return approvedLeaveCount;
}

  // Firestore'daki "users" koleksiyonu altındaki tüm dokümantasyonların içindeki "leaveRequests" koleksiyonlarının
// içindeki dokümantasyonların onay belgesi "REDDEDİLDİ" olanlarının sayısını elde etmek için fonksiyon
Future<int> getRejectLeaveCount() async {
  int rejectLeaveCount = 0;

  QuerySnapshot userDocs = await userCollection.get();


  for (QueryDocumentSnapshot userDoc in userDocs.docs) {

    CollectionReference leaveRequestsCollection =
        userDoc.reference.collection("leaveRequests");

    QuerySnapshot rejectLeaveRequests = await leaveRequestsCollection
        .where("onay", isEqualTo: "REDDEDİLDİ")
        .get();

    rejectLeaveCount += rejectLeaveRequests.size;
  }

  return rejectLeaveCount;
}

// Firestore'daki "users" koleksiyonu altındaki tüm dokümantasyonların içindeki "leaveRequests" koleksiyonlarının
// içindeki dokümantasyonların icindeki baslangicTarihi ve bitisTarihi bir zaman aralığı olsun
//eger şu anki zaman o zaman aralığı içinde olursa bana bu  belgeye ait olan dökümasyonların sayısını döndür. 

  Future<int> getLeaveRequestsInTimeRange() async {
    int count = 0;

    QuerySnapshot userDocs = await userCollection.get();

    // Get the current time
    DateTime currentTime = DateTime.now();

    for (QueryDocumentSnapshot userDoc in userDocs.docs) {
      CollectionReference leaveRequestsCollection =
          userDoc.reference.collection("leaveRequests");

      // Query for documents with "baslangicTarihi" less than or equal to the current time
      QuerySnapshot startQuery = await leaveRequestsCollection
          .where("baslangicTarihi", isLessThanOrEqualTo: currentTime)
          .get();

      // Query for documents with "bitisTarihi" greater than or equal to the current time
      QuerySnapshot endQuery = await leaveRequestsCollection
          .where("bitisTarihi", isGreaterThanOrEqualTo: currentTime)
          .get();

      // Combine the results of both queries
      List<QueryDocumentSnapshot> startDocs = startQuery.docs;
      List<QueryDocumentSnapshot> endDocs = endQuery.docs;

      // Iterate through the documents in both queries to find common documents
      for (QueryDocumentSnapshot startDoc in startDocs) {
        for (QueryDocumentSnapshot endDoc in endDocs) {
          if (startDoc.id == endDoc.id) {
            count++;
            break;
          }
        }
      }
    }
    return count;
  }


  // hey chatGpt SANA BIR SORUM OLACAK. Firestore'daki "users" koleksiyonu altındaki tüm dokümantasyonların içinde username belgesi var mi diye
  // kontrol etmeni istiyorum eger yoksa sayisini elde etmek istiyorum

    // Kullanıcı dokümantasyonlarının içinde "username" alanı yok mu ?kullanici aktivasyon sayisini belirtiyor bu
  Future<int> getUsernameCount() async {
    int usernameCount = 0;

    QuerySnapshot userDocs = await userCollection.get();


    for (QueryDocumentSnapshot userDoc in userDocs.docs) {
      // Dokümantasyonun verilerini al
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      if (!userData.containsKey("username")) {
        usernameCount++;
      }
    }

    return usernameCount;
  }
}




