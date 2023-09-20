import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userDepartmentKey = "USERDEPARTMENTKEY";
  static String userRoolKey = "USERROOLKEY";

  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, username);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserDepartmentSF(String userDepartment) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userDepartmentKey, userDepartment);
  }

  static Future<bool> saveUserRoolDepartmentSF(String userRool) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userRoolKey, userRool);
  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserDepartmentFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userDepartmentKey);
  }

  static Future<String?> getUserRoolFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userRoolKey);
  }
}



// SharedPreferences kütüphanesi kullanarak kullanıcı verilerini (giriş durumu, kullanıcı adı, e-posta, bölüm ve rol gibi) 
//cihazda depolamak ve geri almak için kullanılır. SharedPreferences, küçük miktarlarda yapılandırma veya kullanıcı verisi gibi
// basit verileri cihazda kalıcı olarak saklamak için kullanılır.

// Kullanıcının giriş durumunu (logged in veya logged out) depolamak ve geri almak için saveUserLoggedInStatus ve 
//getUserLoggedInStatus işlevlerini sağlar.
// Kullanıcı adını (userNameKey), e-posta adresini (userEmailKey), bölümü (userDepartmentKey) ve rolü (userRoolKey) depolamak ve
// geri almak için ilgili işlevleri sağlar. Bu işlevler, kullanıcının uygulama içindeki profil bilgilerini ve ayarlarını 
//depolamak için kullanılabilir.
//kullanıcı giriş yaptığında saveUserLoggedInStatus işlevi kullanılarak giriş durumu kaydedilir ve kullanıcı bilgileri 
//saklanabilir. Bu bilgilere ihtiyaç duyulduğunda da getUserLoggedInStatus ve diğer işlevler kullanılarak geri alınabilir.
// Bu şekilde, kullanıcı verileri uygulama oturumu boyunca veya cihaz yeniden başlatıldığında dahi korunmuş olur.
